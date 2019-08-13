# encoding: utf-8
#
# Класс WordReader, отвечающий за чтение слова для игры.
class WordReader
  def read_from_args
    ARGV[0]
  end

  def read_from_file(file_name)
    raise RuntimeError.new 'Слово не найдено. Проверьте word.txt' if File.exist?(file_name) == false

    lines = File.readlines(file_name, encoding: 'UTF-8')

    lines.sample.chomp
  end
end
