use std::io;
use rand::prelude::*;
use std::cmp::Ordering;

fn main() {
    println!("Guess the number!");

    // pick random number from rand crate
    let secret_number = rand::thread_rng().gen_range(1..101);

    // check if they are equal.
    loop {
        println!("Please input your guess.");

        // create mutable variable to store guesses
        let mut guess = String::new();
        
        // get user input 
        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");
        
        // cast guess variable as unsigned int32
        let guess: u32 = match guess.trim().parse() { 
            Ok(num) => num,
            Err(_) => continue,
        };
        
        println!("You guessed: {}", guess);

        // compare guess to secret number
        match guess.cmp(&secret_number) { 
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("Just right!");
                break;
            }
        }
    } 

    println!("You guessed the secret number is {}", secret_number);
    println!("Have a cookie 🍪!");

}