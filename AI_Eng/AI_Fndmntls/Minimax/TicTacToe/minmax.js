function bestMove() {
  let bestScore = -1000000;
  let move;
  for (let i = 0; i < 3; i++) {
    for (let j = 0; j < 3; j++) {
      //Espacio disponible
      if (tablero[i][j] == "") {
        tablero[i][j] = ai;

        let score = minimax(tablero, 0, false);
        tablero[i][j] = "";
        console.log("Scores q pude: " + score);
        if (score > bestScore) {
          bestScore = score;
          move = { i, j };
        }
      }
    }
  }
  console.log("Score mejor: " + bestScore);
  tablero[move.i][move.j] = ai;
  currentPlayer = human;
  console.log("OTRRAAA");
}

let scores = {
  X: Infinity,
  O: -Infinity,
  tie: 0,
};

//isMaximazing permite saber el turno de max  o de min y actuar sobre eso
function minimax(tablero, depth, isMax) {
  let result = checkWinner();
  if (result !== null) {
    //Ya hay un ganador
    // console.log(depth);
    return scores[result];
  }
  //
  if (depth > 0) {
    let heuristickResult = getHeuristickResult();
    return heuristickResult;
  }

  //console.log(depth)
  if (isMax) {
    // console.log("ES MAX ---");
    let bestScore = -Infinity;
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        // Is the spot available?
        if (tablero[i][j] == "") {
          tablero[i][j] = ai;
          let score = minimax(tablero, depth + 1, false);
          tablero[i][j] = "";
          bestScore = max(score, bestScore);
        }
      }
    }
    // console.log("MAX : " + bestScore);

    return bestScore;
  } else {
    // console.log("ES MIN ---");
    //Turno de mini
    let worstScore = Infinity;
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        // Is the spot available?
        if (tablero[i][j] == "") {
          tablero[i][j] = human;
          let score = minimax(tablero, depth + 1, true);
          tablero[i][j] = "";
          worstScore = min(score, worstScore);
        }
      }
    }
    // console.log("MINI : " + worstScore);

    return worstScore;
  }
}
