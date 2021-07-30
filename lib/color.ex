defmodule Color do
  @moduledoc """
  Defines Ecto Color Type
  """
  use Ecto.ParameterizedType

  def type(_params), do: :string

  def init(opts), do: Enum.into(opts, %{})

  def cast(nil, _meta), do: {:error, message: error_message()}
  def cast(color, meta) when is_binary(color), do: validate_color(color, meta)
  def cast(_, _meta), do: :error

  defp validate_color(color, meta) do
    if Regex.match?(~r/^#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/, String.upcase(color)),
      do: {:ok, color},
      else: {:error, message: error_message(meta.field)}
  end

  defp error_message(), do: "can't be blank"
  defp error_message(:rims_color), do: "invalid rims color"
  defp error_message(:body_color), do: "invalid body color"

  def load(color, _loader, _meta) when is_binary(color), do: {:ok, color}
  def load(_color, _loader, _meta), do: :error

  def dump(color, _dumper, _meta) when is_binary(color), do: {:ok, color}
  def dump(_color, _dumper, _meta), do: :error
end
