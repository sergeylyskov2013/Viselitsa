# encoding: utf-8
#
# Популярная детская игра, Виселица
# https://ru.wikipedia.org/wiki/Виселица_(игра)

#require 'unicode_utils/upcase'

require_relative 'lib/game'
require_relative 'lib/result_printer'
require_relative 'lib/word_reader'

# Записываем версию игры в константу VERSION
VERSION = 'Игра виселица, версия 4.0. (c) Хороший программист'

# Создаем экземпляр класса WordReader
word_reader = WordReader.new
# читаем файл со словами для отгадывания
words_file_name = "#{File.dirname(__FILE__)}/data/words.txt"
# создаем переменную которая яв-ся результатом считывания файла words.txt
# и применения метода read_from_file который возвращает строку со словом
# экземпляру класса WordReader
word = word_reader.read_from_file(words_file_name)

# Создаем игру
game = Game.new(word)
# выводим версию игры с помощью сеттера version=
game.version = VERSION

# На экран выводится интерфейс игры
printer = ResultPrinter.new(game)

# Условие продолжения игры
while game.in_progress?
  printer.print_status(game)
  game.ask_next_letter
end
# Выводим статус игры
printer.print_status(game)
