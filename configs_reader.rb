require "yaml"

class ConfigsReader 
  def initialize
    configs = YAML.load_file('configs.yml')
    @word_max_count = configs["word max count"]
    @word_max_length = configs["word max length"]
  end

  def get_word_max_count
    @word_max_count
  end

  def get_word_max_length
    @word_max_length
  end
end
