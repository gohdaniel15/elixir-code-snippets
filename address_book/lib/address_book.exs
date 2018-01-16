defmodule AddressBook do

  @name {:global, AddressBookAgent}
  # @name :address_book_agent

  # API
  def start_link do
    Agent.start_link(&Map.new/0, name: @name)
  end

  def add_name(name, number) do
    Agent.update(@name, &do_add_name(&1, name, number))
  end

  def get_names do
    Agent.get(@name, &do_get_names(&1))
  end

  # Implementation
  defp do_add_name(map, name, number) do
    Map.put_new(map, name, number)
  end

  defp do_get_names(map) do
    Map.to_list(map)
  end

end
