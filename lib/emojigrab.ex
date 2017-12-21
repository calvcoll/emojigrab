defmodule EmojiGrab do
  @moduledoc """
  Documentation for EmojiGrab.
  """

  @doc """
  Hello world.

  ## Examples

      iex> EmojiGrab.hello
      :world

  """
  def main (args \\ []) do
    HTTPoison.start
    case HTTPoison.get "https://niu.moe/api/v1/custom_emojis" do
      {:ok, %HTTPoison.Response{status_code: 200, body: body }} ->
        Poison.decode!(body, as: [%Emoji{}]) |>
          downloadEmoji
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def downloadEmoji (emoji_list) do
    Enum.each(emoji_list, fn(emoji) -> getEmoji(emoji) end)
    writeEmojiJSON emoji_list
  end

  def writeEmojiJSON (emoji_list) do
    string = Enum.reduce(emoji_list, "", fn(emoji, acc) ->
      Enum.join([acc, '#{emoji.shortcode}, /emoji/#{emoji.shortcode}.png\n'], "")
    end)
    File.write!("emoji/emoji.txt", string)
  end

  def getEmoji (emoji) do
    case HTTPoison.get emoji.url do
      {:ok, %HTTPoison.Response{status_code: 200, body: body }} ->
        File.write!("emoji/#{emoji.shortcode}.png", body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
