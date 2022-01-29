module Fiora::Commands
  module Fun
    module EightBall
      extend Discordrb::Commands::CommandContainer
      ANSWERS = [
        "It is certain.",
        "It is decidedly so.",
        "Without a doubt.",
        "Yes definitely.",
        "You may rely on it.",
        "As I see it, yes.",
        "Most likely.",
        "Outlook good.",
        "Yes.",
        "Signs point to yes",
        "Reply hazy, try again.",
        "Ask again later.",
        "Cannot predict now",
        "Concentrate and ask again.",
        "Don't count on it",
        "My reply is no.",
        "My sources say no.",
        "Outlook not so good.",
        "Very doubtful"]

      command(:'8ball') do |event,*text|
        rng = Random.new
        event.message.reply!(ANSWERS[rng.rand(20)])
      end
    end
  end
end