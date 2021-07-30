defmodule SchemaTest do
  @moduledoc false

  use ExUnit.Case

  describe "changeset/2" do
    @valid_params %{brand: "BWM", model: "X5", body_color: "#FF1212", rims_color: "#010101"}
    @invalid_params %{brand: nil, model: nil, body_color: nil, rims_color: nil}

    test "returns a valid changeset when passing valid params" do
      assert %Ecto.Changeset{valid?: true} = Car.changeset(%Car{}, @valid_params)
    end

    test "returns an invalid changeset when passing invalid params" do
      changeset = Car.changeset(%Car{}, @invalid_params)
      assert "can't be blank" in errors_on(changeset)[:brand]
      assert "can't be blank" in errors_on(changeset)[:model]
      assert "can't be blank" in errors_on(changeset)[:body_color]
      assert "can't be blank" in errors_on(changeset)[:rims_color]
    end

    test "validates colors" do
      invalid_params =
        @valid_params
        |> Map.put(:body_color, "#1234")
        |> Map.put(:rims_color, "#1234567")

      changeset = Car.changeset(%Car{}, invalid_params)
      assert "invalid body color" in errors_on(changeset)[:body_color]
      assert "invalid rims color" in errors_on(changeset)[:rims_color]
    end
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn
        {:type, {:parameterized, Color, %{field: _field}}}, acc ->
          acc

        {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
