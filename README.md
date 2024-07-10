Rock Paper Scissors in MIPS Assembly
Overview

This project implements the classic game of Rock Paper Scissors, but with a twist: the computer plays against itself. The game is developed using MIPS Assembly and involves generating random moves, comparing them, and determining the winner.
Features

    Random Move Generation: Uses MIPS random number generation syscalls to generate moves for both players.
    Game Simulation: Simulates a single round of Rock Paper Scissors and announces the winner.
    Cellular Automata: Incorporates a cellular automaton to generate pseudorandom numbers as an alternative method.

Project Structure

    random.s: Contains functions to generate random bits and bytes.
    rps.s: Simulates the game and announces the result.
    automaton.s: Implements the cellular automaton used for generating pseudorandom numbers.

How to Run
Prerequisites

    MARS (MIPS Assembler and Runtime Simulator)

Steps

    Clone the Repository:

    sh

git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name

Open MARS:

    Place the Mars4_5.jar file into the root directory of your project.
    Start MARS from the command line within your project directory:

sh

    java -jar Mars4_5.jar

    Assemble and Run:
        Tick the settings for "Assemble all files in directory" and "Initialize Program Counter to global ‘main’ if defined".
        Load and run the .s files to simulate the game.

Implementation Details
Random Number Generation

    gen_bit: Queries the random number generator for the next number and returns its least significant bit.
    gen_byte: Uses bits produced by gen_bit to generate one of three equally likely outcomes (Rock, Paper, or Scissors).

Game Simulation

    play_game_once: Simulates a single round of Rock Paper Scissors. Calls gen_byte twice to generate moves for both players and announces the result.

Cellular Automata

    print_tape: Prints the current tape of the ECA.
    simulate_automaton: Simulates one generation of the ECA and updates the tape accordingly.
    gen_bit (updated): Uses the ECA to generate a random bit if eca is non-zero.

Testing and Debugging

    Testing: Use the provided run_tests script to test your implementation against predefined tests.
    Debugging: Use the verbose flag ./run_tests -v for detailed information, and the debug option ./run_tests {path_to_test.s} --debug to manually step through test scenarios.

Additional Resources

    Elementary Cellular Automaton
    Conway's Game of Life
