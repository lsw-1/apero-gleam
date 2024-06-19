import app/pages/home
import app/pages/layout
import app/web
import gleam/string_builder
import lustre/element
import wisp.{type Request, type Response}

/// The HTTP request handler- your application!
/// 
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["foo", "bar"] -> {
      let body = string_builder.from_string("<h1>Foo, Bar!</h1>")
      wisp.html_response(body, 200)
    }
    ["favicon.ico"] -> static_file(req)
    [] -> {
      // Give the home page by default.
      home.home_page()
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
    _ -> wisp.not_found()
  }
}

fn static_file(req: Request) -> Response {
  use <- wisp.serve_static(req, under: "/", from: "./priv/static/")
  wisp.ok()
}
