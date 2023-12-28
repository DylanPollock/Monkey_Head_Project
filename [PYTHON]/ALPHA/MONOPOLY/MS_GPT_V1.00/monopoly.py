import json
import random
import logging

#Constants
PIECES = ["Car", "Top Hat", "Thimble", "Boot", "Dog", "Wheelbarrow", "Battleship", "Cat"]
JAIL_FEE = 50

try:
    with open('board.json') as f:
        board = json.load(f)
except (FileNotFoundError, json.JSONDecodeError) as e:
    print(f"Error loading board file: {e}")
    exit(1)
except Exception as e:
    print(f"Unexpected error: {e}")
    exit(1)

# Game State Representation
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
        return self.houses == 4 and not self.hotel and self.owner.money >= self.hotel_cost

class Game:
    def __init__(self, players, properties):
        self.players = players
        self.properties = properties
        self.current_player = players[0]

class Player:
    def __init__(self, name, piece):
        self.name = name
        self.piece = piece
        self.position = 0
        self.properties = []
        self.money = 1500
        self.in_jail = False
        self.get_out_of_jail_free = False

    def can_afford(self, cost):
        return self.money >= cost

class Move:
    def __init__(self, player, action, property=None):
        self.player = player
        self.action = action
        self.property = property

def roll_dice():
    dice1 = random.randint(1, 6)
    dice2 = random.randint(1, 6)
    return dice1 + dice2

def generate_moves(game):
    moves = [Move(game.current_player, 'roll_dice')]
    player = game.current_player

    # Only consider properties that can be bought
    for prop in game.properties:
        if prop.type == 'property' and prop.can_be_bought() and player.can_afford(prop.cost):
            moves.append(Move(player, 'buy', prop))
    
    return moves

def evaluate_move(game, move):
    # This function will need to be updated with your actual game logic
    return random.randint(1, 100)

def choose_move(game, player):
    possible_moves = generate_moves(game)
    best_move = max(possible_moves, key=lambda move: evaluate_move(game, move))
    return best_move

def make_move(game, move):
    player = move.player
    if move.action == "move":
        dice_roll = roll_dice()
        player.position = (player.position + dice_roll) % len(game.board)
        print(f"{player.name} moved to position {player.position}")
    elif move.action == "buy":
        property_to_buy = move.property
        property_to_buy.owner = player
        player.properties.append(property_to_buy)
        player.money -= property_to_buy.cost
        print(f"{player.name} bought {property_to_buy.name}")
    elif move.action == "build":
        property_to_build = move.property
        property_to_build.houses += 1
        player.money -= property_to_build.house_cost
        print(f"{player.name} built a house on {property_to_build.name}")
    elif move.action == "upgrade":
        property_to_upgrade = move.property
        property_to_upgrade.hotel = True
        player.money -= property_to_upgrade.hotel_cost
        print(f"{player.name} upgraded a house to a hotel on {property_to_upgrade.name}")
    elif move.action == "sell":
        property_to_sell = move.property
        player.properties.remove(property_to_sell)
        player.money += property_to_sell.cost
        print(f"{player.name} sold {property_to_sell.name}")
    elif move.action == "sell house":
        property_to_sell_house = move.property
        property_to_sell_house.houses -= 1
        player.money += property_to_sell_house.house_cost // 2
        print(f"{player.name} sold a house on {property_to_sell_house.name}")
    elif move.action == "sell hotel":
        property_to_sell_hotel = move.property
        property_to_sell_hotel.hotel = False
        player.money += property_to_sell_hotel.hotel_cost // 2
        print(f"{player.name} sold a hotel on {property_to_sell_hotel.name}")
    elif move.action == "use_card":
        player.get_out_of_jail_free = False
        print(f"{player.name} used a 'Get Out of Jail Free' card")
    elif move.action == "pay":
        player.money -= JAIL_FEE
        print(f"{player.name} paid {JAIL_FEE} to get out of jail")
    elif move.action == "roll":
        dice_roll = roll_dice()
        if dice_roll > 6:
            player.in_jail = False
            player.position = (player.position + dice_roll) % len(game.board)
            print(f"{player.name} rolled a {dice_roll} and got out of jail")
        else:
            print(f"{player.name} rolled a {dice_roll} and is still in jail")

def game_over(game):
    # This function will need to be updated with your actual game logic
    return False

def play_game(game):
    while not game_over(game):
        move = choose_move(game, game.current_player)
        make_move(game, move)
        next_player(game)

def next_player(game):
    current_index = game.players.index(game.current_player)
    game.current_player = game.players[(current_index + 1) % len(game.players)]
    print(f"It's now {game.current_player.name}'s turn")

logger = logging.getLogger(__name__)
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter('%(message)s'))
logger.addHandler(handler)
logger.setLevel(logging.INFO)

def main():
    logger.info("Monopoly Simulation")

    logger.info("Loading board...")
    properties = [Property(**prop) for prop in board]

    player_count = int(input("How many players? (1-7): "))
    if player_count < 1 or player_count > 7:
        print("Invalid number of players. Please enter a number between 1 and 7.")
        return

    # Create players
    players = [Player(f"Player {i+1}", piece) for i, piece in enumerate(PIECES[:player_count])]

    # Add AI player if there are less than 8 players
    if player_count < 8:
        players.append(Player("AI", PIECES[player_count]))

    logger.info("Starting game...")

    # Create and play game
    game = Game(players, properties)
    play_game(game)

if __name__ == "__main__":
    main()
