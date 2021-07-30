defmodule Car do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Color

  @required ~w(brand model body_color rims_color)a

  schema "cars" do
    field :brand, :string
    field :model, :string
    field :body_color, Color, default: "#FF9900"
    field :rims_color, Color, default: "#000000"
  end

  def changeset(car, params \\ %{}) do
    car
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
