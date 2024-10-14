# PollerPhx
Contains RESTful endpoints (controllers, actions), authentication Plugs/Pipelines, views (JSON encoders/decoders), and Phoenix channels for **real-time** voting.

## Dependencies
It depends on:
  1. Poller project - to:
      - start up PollServer(GenServer) of the corresponding district, by using the PollerSupervisor(DynamicSupervisor).
      - relay vote requests to their corresponding PollServer(GenServer), according to the vote request' district data.
      - get latest votes data, when a user joins a district' channel for **real-time** poll resutls.

  2. PollerDal project - to interact with the Postgres database

  3. Guardian lib - a simple yet powerful token-based authentication library

  4. corsica lib - to deal with CORS(Cross-Origin Resource Sharing) requests and responses
      - it provides a plug out of the box that handles CORS requests and responds to preflight requests

  5. argon2_elixir lib - a Argon2 password hashing implmentation for Elixir


## Design decisions
### Fetching & Loading references/entities
We decided to reference resources using links/hrefs 
instead of providing just an Id which should be opaque (not be used consumer-side to construct resource URI).

Another alternative would be the introduction of "_expand" query param:
`GET RESOURCE_URL?_expand=*` to expand all relations or `GET RESOURCE_URL?_expand=RELATION_NAME` to expand a specific relation.<br/>
As a reminder, we prefix the query param with underscore if it is not a state/attribute related to the resource.


## Getting started

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Generated 
  . using 
    > mix phx.new poller_phx --no-ecto --no-html --no-webpack

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
