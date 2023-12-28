#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ================================================== #
# This file is a part of PYGPT package               #
# Website: https://pygpt.net                         #
# GitHub:  https://github.com/szczyglis-dev/py-gpt   #
# MIT License                                        #
# Created By  : Marcin Szczygliński                  #
# Updated Date: 2023.12.25 21:00:00                  #
# ================================================== #

import pytest
from unittest.mock import MagicMock, mock_open, patch
from PySide6.QtWidgets import QMainWindow

from langchain.schema import SystemMessage, HumanMessage, AIMessage
from pygpt_net.config import Config
from pygpt_net.core.chain import Chain
from pygpt_net.item.ctx import CtxItem
from pygpt_net.item.model import ModelItem


@pytest.fixture
def mock_window():
    window = MagicMock(spec=QMainWindow)
    window.core = MagicMock()
    window.core.config = MagicMock(spec=Config)
    window.core.config.path = 'test_path'
    window.core.models = MagicMock()
    return window


def test_call(mock_window):
    """
    Test call
    """
    ctx = CtxItem()
    ctx.input = 'test_input'

    model = ModelItem()
    model.name = 'test'
    model.langchain = {
        'provider': 'test',
        'mode': ['chat', 'completion']
    }

    mock_window.core.models.get.return_value = model
    chain = Chain(mock_window)
    chain.chat = MagicMock()
    chain.chat.send.content = MagicMock()
    chain.completion.send = MagicMock()
    chain.chat.send.content.return_value = 'test_chat_response'
    chain.completion.send.return_value = 'test_completion_response'

    chain.call('test_text', ctx)
    chain.chat.send.assert_called_once_with('test_text', False, system_prompt=None, ai_name=None, user_name=None)
