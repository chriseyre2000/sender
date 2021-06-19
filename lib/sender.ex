defmodule Sender do
  def send_email(_email) do
    Process.sleep(3_000)
    IO.puts("Email to #{Email} sent")
    {:ok, "email_sent"}
  end
end
