defmodule Scaffold.Router do
  use Plug.Router

  # 1. THE GATEKEEPER: Add CORS headers to every request
  plug CORSPlug, origin: ["http://localhost:5173"]
  plug Plug.Logger, log: :debug

  plug :match
  plug :dispatch

  # 2. THE CONTRACT: Decode the binary payload
  post "/api" do
    {:ok, body, conn} = read_body(conn)
    
    # Decode
    request = Base.V1.ServiceRequest.decode(body)
    
    # Logic
    response_data = case request.payload do
      {:ping, msg} -> 
        # FIX: Use Struct syntax (%Base.V1.Pong{}) instead of .new()
        %Base.V1.Pong{
          timestamp: msg.timestamp,
          server_name: "Protocol Zero Core (Sovereign)"
        }
    end
    
    # Encode
    encoded_resp = Base.V1.Pong.encode(response_data)
    
    conn
    |> put_resp_content_type("application/octet-stream")
    |> send_resp(200, encoded_resp)
  end

  # 3. OPTIONS Handler (Browser Pre-flight check)
  options _ do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Unknown Protocol")
  end
end
