defmodule Emoji do
    @derive [Poison.Encoder]
    defstruct [:shortcode, :url]

end