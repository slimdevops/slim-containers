use std::io::prelude::*;
use std::net::TcpListener;
use std::net::TcpStream;
use std::fs::File;

fn main() {
    println!("entered main");
    let listener = TcpListener::bind("0.0.0.0:7878").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        println!("calling for handle connection");
        handle_connection(stream);
    }
}

fn handle_connection(mut stream: TcpStream) {
    println!("attempting connection");
    let mut buffer = [0; 512];
    stream.read(&mut buffer).unwrap();
    println!("connection complete");

    let get = b"GET / HTTP/1.1\r\n";

    let (status_line, filename) = if buffer.starts_with(get) {
        ("HTTP/1.1 200 OK\r\n\n", "/assets/hello.html")
    } else {
        ("HTTP/1.1 404 NOT FOUND\r\n\n", "/assets/404.html")    
    };

    let mut file = File::open(filename).unwrap();
    let mut contents = String::new();

    file.read_to_string(&mut contents).unwrap();

    let response = format!("{} {}", status_line, contents);

    stream.write(response.as_bytes()).unwrap();
    println!("response written");
    stream.flush().unwrap();    
    
}