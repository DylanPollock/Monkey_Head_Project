import json
import random
import logging

# Set up logger
logger = logging.getLogger(__name__)
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logger.addHandler(handler)
logger.setLevel(logging.INFO)

# Classes
class Property:
    def __init__(self, name, position, cost=None, rent=None, house_cost=None, rent_with_house=None, type=None):
        self.name = name
        self.position = position
        self.cost = cost
        self.rent = rent
        self.house_cost = house_cost
        self.rent_with_house = rent_with_house
        self.type = type
        self.rent_with_hotel = rent_with_house[-1] if rent_with_house else None
        self.owner = None
        self.houses = 0
        self.hotel = False

    def can_be_bought(self):
        return self.owner is None

    def can_be_built(self):
        return self.houses < 4 and self.owner.money >= self.house_cost

    def can_be_upgraded(self):
        return self.houses == 4 and not self.hotel and self.owner.money >= self.house_cost
    
class Game:
    def __init__(self, players, properties, board):
        self.players = players
        self.properties = properties
        self.board = board
        self.current_player = players[0]

class Player:
    def __init__(self, name, piece):
        self.name = name
        self.piece = piece
        self.position = 0
        self.properties = []
        self.money = 1500
        self.in_jail = False
        self.get_out_of_jail_free_cards = 0
        self.first_turn = True
        self.doubles_count = 0

    def can_afford(self, cost):
        return self.money >= cost

    def can_roll(self):
        if self.in_jail:
            return False
        else:
            return True

    def is_bankrupt(self):
        return self.money <= 0

    def choose_action(self):
        actions = ["roll", "bank", "buy", "sell", "mortgage"]
        logger.info('Please choose an action: %s', ', '.join(actions))
        action = input()
        while action not in actions:
            logger.info('Invalid action, please choose one of the following: %s', ', '.join(actions))
            action = input()
        return action

class Move:
    def __init__(self, player, action, property=None):
        self.player = player
        self.action = action
        self.property = property


class ChanceOrCommunityChest(Property):
    def __init__(self, name, deck):
        super().__init__(name)
        self.deck = deck

    def land(self, player, game):
        card = self.deck.draw()
        card.execute(player, game)

class Action:
    ROLL = "roll"
    BUY = "buy"
    SELL = "sell"
    MORTGAGE = "mortgage"
    UNMORTGAGE = "unmortgage"
    SELL_HOUSE = "sell_house"
    SELL_HOTEL = "sell_hotel"
    USE_CARD = "use_card"
    PAY = "pay"
    ROLL_IN_JAIL = "roll_in_jail"
    BUILD = "build"
    TRADE = "trade"
    END_TURN = "end_turn"

#Loading Functions
def load_rules():
    try:
        with open('RULES.txt', 'r') as f:
            rules = f.read().splitlines()
    except FileNotFoundError:
        logger.error("RULES.txt not found in the current directory.")
        raise FileNotFoundError("RULES.txt not found in the current directory.")
    return rules

def load_constants():
    try:
        with open('constants.json', 'r') as file:
            constants = json.load(file)
    except FileNotFoundError:
        logger.error("constants.json not found in the current directory.")
        raise FileNotFoundError("constants.json not found in the current directory.")
    except json.JSONDecodeError:
        logger.error("Error decoding JSON data in constants.json.")
        raise json.JSONDecodeError("Error decoding JSON data in constants.json.")
    return constants   

def load_players(pieces):
    players = []
    while True:
        try:
            player_count = int(input("How many players? (1-7): "))
            if 1 <= player_count <= 7:
                break
            else:
                logger.error("Invalid number of players. Please enter a number between 1 and 7.")
        except ValueError:
            logger.error("Invalid input. Please enter a number.")
        continue
    for i in range(player_count):
        while True:
            name = input(f"Enter player {i+1}'s name: ").strip()
            if name:
                break
            else:
                logger.error("Name cannot be empty. Please enter a valid name.")

        while True:
            print("Choose a piece:")
            for j, piece in enumerate(pieces):
                print(f"{j+1}. {piece}")
            try:
                piece_index = int(input("Enter the number of your piece: ")) - 1
                if 0 <= piece_index < len(pieces):
                    piece = pieces.pop(piece_index)
                    break
                else:
                    logger.error("Invalid piece number. Please enter a number corresponding to an available piece.")
            except ValueError:
                logger.error("Invalid input. Please enter a number.")
        players.append(Player(name, piece))
        
    ai_piece = pieces[0]
    pieces.remove(ai_piece)
    players.append(Player("AI", ai_piece))
        
    return players

#Basic Functions
def roll_dice():
    dice1 = random.randint(1, 6)
    dice2 = random.randint(1, 6)
    is_double = dice1 == dice2
    return dice1 + dice2, is_double

def draw_card(deck):
    card = random.choice(deck)
    deck.remove(card)
    if len(deck) == 0:
        deck = constants[deck].copy()
    return card

#Player Functions
def print_player_info(players):
    for player in players:
        logger.info(f"{player.name} ({player.piece}): ${player.money}")

def next_player(game):
    current_index = game.players.index(game.current_player)
    game.current_player = game.players[(current_index + 1) % len(game.players)]
    logger.info(f"It's now {game.current_player.name}'s turn")

def determine_turn_order(players):
    rolls = {player: roll_dice() for player in players}
    logger.info("Roll results:")
    for player, roll in rolls.items():
        logger.info(f"{player.name} rolled a total of {roll[0]}")

    sorted_players = sorted(players, key=lambda p: rolls[p][0], reverse=True)
    max_roll = max(rolls.values(), key=lambda x: x[0])[0]

    while list(roll[0] for roll in rolls.values()).count(max_roll) > 1:
        tie_players = [player for player in players if rolls[player][0] == max_roll]
        logger.info(f"There's a tie between {', '.join(player.name for player in tie_players)}. They roll again.")
        for player in tie_players:
            rolls[player] = roll_dice()
            logger.info(f"{player.name} rolled a total of {rolls[player][0]}")
        sorted_players = sorted(players, key=lambda p: rolls[p][0], reverse=True)
        max_roll = max(rolls.values(), key=lambda x: x[0])[0]

    logger.info("Turn order:")
    for i, player in enumerate(sorted_players, 1):
        logger.info(f"{i}. {player.name}")
    return sorted_players

def mortgage_property(player, property):
    if property.is_mortgaged:
        print("This property is already mortgaged")
    else:
        player.cash += property.mortgage_value
        property.is_mortgaged = True

def get_property_from_input(player, action_type):
    for i, prop in enumerate(player.properties):
        logger.info(f"{i+1}. {prop.name}")
    property_index = int(input(f"Enter the number of the property you want to {action_type}: ")) - 1
    return player.properties[property_index]

#Move Functions
def generate_moves(game):
    moves = []
    player = game.current_player

    if player.can_roll():
        moves.append(Move(player, 'roll'))

    for prop in game.properties:
        if prop.type == 'property' and prop.can_be_bought() and player.can_afford(prop.cost):
            moves.append(Move(player, 'buy', prop))
    
    return moves

def evaluate_move(game, move):
    return random.randint(1, 100)

def choose_move(game, player):
    if player.name != "AI":
        while True:
            action = player.choose_action()
            if action == "roll":
                return Move(player, Action.ROLL)
            elif action == "buy":
                property_to_buy = next((prop for prop in game.properties if prop.position == player.position and prop.can_be_bought() and prop.cost is not None), None)
                if property_to_buy:
                    if player.can_afford(property_to_buy.cost):
                        return Move(player, Action.BUY, property_to_buy)
                    else:
                        logger.info("You cannot afford this property.")
                else:
                    logger.info("You cannot buy any property at your current position.")
            elif action == "sell":
                if player.properties:
                    property_to_sell = get_property_from_input(player, 'sell')
                    return Move(player, 'sell', property_to_sell)
                else:
                    logger.info("You don't own any properties.")
            elif action == "bank":
                logger.info(f"{player.name} has ${player.money}")
                continue
            elif action == "mortgage":
                if player.properties:
                    property_to_mortgage = get_property_from_input(player, 'mortgage')
                    return Move(player, 'mortgage', property_to_mortgage)
                else:
                    logger.info("You don't own any properties.")
                continue
            elif action == "end_turn":
                return Move(player, Action.END_TURN)
            else:
                logger.info('Invalid action, please choose one of the following: "roll", "bank", "buy", "sell", "mortgage", "help"')
                continue

            if move in possible_moves:
                return move
            else:
                logger.info("Invalid move. Please try again.")
                continue
    else:
        possible_moves = generate_moves(game)
        best_move = max(possible_moves, key=lambda move: evaluate_move(game, move))
        return best_move

def make_move(game, move):
    player = move.player

    if move.action == Action.ROLL:
        handle_roll(game, player)
    elif move.action == Action.BUY:
        handle_buy(game, player, move.property)
    elif move.action == Action.SELL:
        sell_type = input("Do you want to sell a property, house, or hotel? Enter 'property', 'house', or 'hotel': ")
        if sell_type == 'property':
            handle_sell_property(game, player, move.property)
        elif sell_type == 'house':
            handle_sell_house(game, player, move.property)
        elif sell_type == 'hotel':
            handle_sell_hotel(game, player, move.property)
    elif move.action == Action.MORTGAGE:
        handle_mortgage(game, player, move.property)
    elif move.action == Action.UNMORTGAGE:
        handle_unmortgage(game, player, move.property)
    elif move.action == Action.BUILD:
        handle_build(game, player, move.property)
    elif move.action == Action.USE_CARD:
        handle_use_card(game, player)
    elif move.action == Action.PAY:
        handle_pay(game, player)
    elif move.action == Action.END_TURN:
        pass
    elif move.action == Action.TRADE:
        logger.info("Trade function not added yet.")
    else:
        logger.info(f"Invalid action {move.action}")
        
def execute_move(game, move):
    player = move.player
    if move.action == 'roll':
        handle_roll(game, player)
    elif move.action == 'buy':
        handle_buy(game, player, move.property)
    else:
        logger.info(f"Invalid action {move.action}")

#Handle Functions
def handle_roll(game, player):
    dice_roll, is_double = roll_dice()
    if is_double:
        player.doubles_count += 1
        logger.info(f"{player.name} rolled '{dice_roll}'")
        if player.doubles_count == 2:
            logger.info(f"{player.name} rolled two doubles in a row!")
        elif player.doubles_count == 1:
            logger.info(f"{player.name} rolled doubles!")
    else:
        player.doubles_count = 0
        logger.info(f"{player.name} rolled '{dice_roll}'")
    if player.doubles_count >= 3:
        player.position = game.jail_position
        player.in_jail = True
        player.doubles_count = 0
        logger.info(f"{player.name} rolled three doubles in a row and goes to jail!")
        return False
    else:
        new_position = (player.position + dice_roll) % len(game.board)
        if not player.first_turn and new_position < player.position:
            player.money += 200
            logger.info(f"{player.name} passed 'Go' and received $200. New balance: ${player.money}")
        player.position = new_position
        logger.info(f"{player.name} moved to position {player.position}")
        player.first_turn = False
        return is_double 

def handle_buy(game, player, property_to_buy):
    property_to_buy.owner = player
    player.properties.append(property_to_buy)
    player.money -= property_to_buy.cost
    logger.info(f"{player.name} bought {property_to_buy.name}")

def handle_sell_property(game, player, property_to_sell):
    player.properties.remove(property_to_sell)
    player.money += property_to_sell.cost // 2
    property_to_sell.owner = None
    logger.info(f"{player.name} sold {property_to_sell.name}")

def handle_sell_house(game, player, property_to_sell_house):
    if property_to_sell_house.houses > 0:
        property_to_sell_house.houses -= 1
        player.money += property_to_sell_house.house_cost // 2
        logger.info(f"{player.name} sold a house on {property_to_sell_house.name}")
    else:
        logger.info(f"{player.name} doesn't have any house on {property_to_sell_house.name}")

def handle_sell_hotel(game, player, property_to_sell_hotel):
    if property_to_sell_hotel.hotel:
        property_to_sell_hotel.hotel = False
        player.money += property_to_sell_hotel.hotel_cost // 2
        logger.info(f"{player.name} sold a hotel on {property_to_sell_hotel.name}")
    else:
        logger.info(f"{player.name} doesn't have a hotel on {property_to_sell_hotel.name}")

def handle_mortgage(game, player, property_to_mortgage):
    if not property_to_mortgage.is_mortgaged:
        property_to_mortgage.is_mortgaged = True
        player.money += property_to_mortgage.cost // 2
        logger.info(f"{player.name} mortgaged {property_to_mortgage.name}")
    else:
        logger.info(f"{property_to_mortgage.name} is already mortgaged")

def handle_unmortgage(game, player, property_to_unmortgage):
    if property_to_unmortgage.is_mortgaged:
        property_to_unmortgage.is_mortgaged = False
        player.money -= property_to_unmortgage.cost // 2
        logger.info(f"{player.name} unmortgaged {property_to_unmortgage.name}")
    else:
        logger.info(f"{property_to_unmortgage.name} is not mortgaged")

def handle_build(game, player, property_to_build):
    if property_to_build in player.properties:
        if property_to_build.hotel:
            logger.info(f"{player.name} cannot build more on {property_to_build.name}")
        elif property_to_build.houses < 4:
            property_to_build.houses += 1
            player.money -= property_to_build.house_cost
            logger.info(f"{player.name} built a house on {property_to_build.name}")
        else:
            property_to_build.houses = 0
            property_to_build.hotel = True
            player.money -= property_to_build.hotel_cost
            logger.info(f"{player.name} built a hotel on {property_to_build.name}")
    else:
        logger.info(f"{player.name} doesn't own {property_to_build.name}")

def handle_use_card(game, player):
    if player.get_out_of_jail_free:
        player.get_out_of_jail_free = False
        player.in_jail = False
        logger.info(f"{player.name} used a 'Get Out of Jail Free' card")
    else:
        logger.info(f"{player.name} doesn't have a 'Get Out of Jail Free' card")

def handle_pay(game, player):
    if player.in_jail:
        player.money -= constants['JAIL_FEE']
        player.in_jail = False
        logger.info(f"{player.name} paid {constants['JAIL_FEE']} to get out of jail")
    else:
        logger.info(f"{player.name} is not in jail")

def handle_roll_to_escape(game, player):
    if player.in_jail:
        dice_roll = roll_dice()
        if dice_roll > 6:
            player.in_jail = False
            player.position = (player.position + dice_roll) % len(game.board)
            logger.info(f"{player.name} rolled a {dice_roll} and got out of jail")
        else:
            logger.info(f"{player.name} rolled a {dice_roll} and is still in jail")
    else:
        logger.info(f"{player.name} is not in jail")

def handle_trade(game, player):
    logger.info(f"Trade function not added yet.")

# Main Functions
def play_game(players, constants):
    rules = load_rules()
    board = constants['PROPERTIES']
    properties = [Property(**prop) for prop in constants['PROPERTIES']]

    game = Game(players, properties, board)

    while not game_over(game):
        player = game.current_player
        turn_over = False
        while not turn_over:
            move = choose_move(game, player)
            if move.action == Action.ROLL:
                turn_over = not handle_roll(game, player)  # handle_roll now returns whether the turn should continue or not
            elif move.action == Action.BUY:
                handle_buy(game, player, move.property)
            elif move.action == Action.END_TURN:
                turn_over = True
            else:
                logger.info(f"Invalid action {move.action}")
                turn_over = True
        current_index = game.players.index(game.current_player)
        game.current_player = game.players[(current_index + 1) % len(game.players)]

    winner = [player for player in game.players if not player.is_bankrupt()][0]
    return winner, game

def game_over(game):
    return len([player for player in game.players if not player.is_bankrupt()]) <= 1

def main():
    logger.info("Monopoly Simulation")

    logger.info("Loading Constants...")
    constants = load_constants()
    properties = [Property(**prop) for prop in constants['PROPERTIES']]
    board = properties
    
    logger.info("Loading Rules...")
    rules = load_rules()
    if not rules:
        logger.error("Error loading rules. Exiting.")
        return

    logger.info("Loading Players...")
    logger.info("Each player chooses one token to represent them while traveling around the board.")
    pieces = constants['TOKENS']
    players = load_players(pieces)

    logger.info("Loading Banker...")
    logger.info("AI will act as Banker.")
    logger.info("Each player is given $1,500 divided as follows: 2 each of $500s, $100s & $50s; 6 $40s; 5 each of $105, $5s & $1s.")
    print_player_info(players)

    logger.info("Starting game...")
    logger.info("Starting with the Banker, each player in turn throws the dice. The player with the highest total starts the play:")
    players = determine_turn_order(players)

    all_constants = constants
    game_over_flag = False
    while not game_over_flag:
        winner, game = play_game(players, all_constants)
        game_over_flag = game_over(game)

    winner = [player for player in players if not player.is_bankrupt()][0]
    logger.info(f"Game over! {winner.name} is the winner!")

# Starts program
if __name__ == "__main__":
    main()
