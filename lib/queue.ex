defmodule Queue do
  use GenServer

  # Client

  def start_link(initial_queue) when is_list(initial_queue) do
    GenServer.start_link(__MODULE__, initial_queue)
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:enqueue, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :dequeue)
  end

  # Server (Callbacks)
  @impl true
  def init(queue) do
    {:ok, queue}
  end

  @impl true
  # sync
  def handle_call({:enqueue, element}, _from, queue) do
    new_queue = queue ++ [element]

    {:reply, new_queue, new_queue}
  end

  @impl true
  def handle_call(:dequeue, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:dequeue, _from, []) do
    {:reply, nil, []}
  end

  @impl true
  # async
  def handle_cast({:enqueue, element}, queue) do
    {:noreply, queue ++ [element]}
  end
end
