defmodule ImageLister do
  @directory "/Users/bgoosman/git/dancehack_2024/scavengr/priv/static/images/locations"

  def list_jpg_files do
    @directory
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".jpg"))
    |> Enum.map(&file_to_map/1)
  end

  defp file_to_map(filename) do
    id = Path.rootname(filename) <> ".jpg"
    %{location_id: id, image: id}
  end
end
