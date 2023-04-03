/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package agentes;

import java.awt.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import java.lang.Math;


/**
 *
 * @author macario
 */
public class Agente extends Thread {

//  THIS PART REFERS TO AN AGENT PROPRIETIES
    String nameAgent; //name fo the agent

    ImageIcon iconAgent; // his icon
    int[][] matrix;
    JLabel board[][]; // The board we are currently in

//    CHARACTERISTICS OF POSITION IN BOARD
    int positionYAgent;
    int positionXAgent;

    JLabel previousSquareInBoard;
    JLabel actualSquareInBoard;
    Random random = new Random(System.currentTimeMillis());


//    ICONS USED WHEN INTERACT WITH THE BOARD
    ImageIcon treeIcon;
    ImageIcon smokeIcon;
    ImageIcon weedTwoIcon;
    ImageIcon weedOneIcon;
    ImageIcon weedThreeIcon;


// also flags whitn interacting with board

    boolean previousSquareWasTree = false;
    boolean gotWeed = false;
    boolean previousSquareWasWeed = false;

//    Also the agent has the coordinates of all the elements in board

    HashMap<ArrayList<Integer>,Double> weedCoordinates = new HashMap<ArrayList<Integer>, Double>();
    HashMap<ArrayList<Integer>,Double> treeCoordinates = new HashMap<ArrayList<Integer>, Double>();
    HashMap<ArrayList<Integer>,Double> copCoordinates = new HashMap<ArrayList<Integer>, Double>();

    ArrayList auxCoordinatesWeed = new ArrayList<Integer>();



    
    public Agente(String nameAgent, ImageIcon iconAgent, int[][] matrix, JLabel board[][],HashMap<ArrayList<Integer>,Double> treeCoordinates, HashMap<ArrayList<Integer>,Double> weedCoordinates, HashMap<ArrayList<Integer>,Double> copCoordinates) {
        //  THIS PART REFERS TO AN AGENT PROPRIETIES
        this.nameAgent = nameAgent;
        this.iconAgent = iconAgent;
        this.matrix = matrix;
        this.board = board;
        this.treeCoordinates = treeCoordinates;
        this.copCoordinates = copCoordinates;
        this.weedCoordinates = weedCoordinates;

        //  THIS PART REFERS TO THE POSITION IN BOARD
        this.positionYAgent = random.nextInt(matrix.length);
        this.positionXAgent = random.nextInt(matrix.length);
        board[positionYAgent][positionXAgent].setIcon(iconAgent);

//        ICONS THAT WILL BE USEFUL INTERACTING WITH BOARD

        treeIcon = new ImageIcon("imagenes/tree.png");
        treeIcon = new ImageIcon(treeIcon.getImage().getScaledInstance(50,50,  Image.SCALE_SMOOTH));
        smokeIcon = new ImageIcon("imagenes/smoke.png");
        smokeIcon = new ImageIcon(smokeIcon.getImage().getScaledInstance(50,50,  Image.SCALE_SMOOTH));
        weedOneIcon = new ImageIcon("imagenes/hemp.png");
        weedOneIcon = new ImageIcon(weedOneIcon.getImage().getScaledInstance(50,50,  Image.SCALE_SMOOTH));
        weedTwoIcon = new ImageIcon("imagenes/2plantas.png");
        weedTwoIcon = new ImageIcon(weedTwoIcon.getImage().getScaledInstance(50,50,  Image.SCALE_SMOOTH));

        weedThreeIcon = new ImageIcon("imagenes/3plantas.png");
        weedThreeIcon = new ImageIcon(weedThreeIcon.getImage().getScaledInstance(50,50,  Image.SCALE_SMOOTH));

//        FLAGS FOR TREE, COP AND GOT WEED
        this.previousSquareWasTree = false;
        this.gotWeed = false;
        this.previousSquareWasWeed = false;

    }




    public void run() {
        while(true) {
//            Lets play
            
            previousSquareInBoard = board[positionYAgent][positionXAgent];
            
//            Next move 
            ArrayList<Integer> newYPosition_newXPosition = this.move2aNewPosition();
            int nextYPosition = newYPosition_newXPosition.get(0);
            int nextXPosition = newYPosition_newXPosition.get(1);
            positionYAgent = positionYAgent + nextYPosition;
            positionXAgent = positionXAgent + nextXPosition;
            

//          We are in a new position so lets check if we are in a weed or a tree
//            For the animation or just we got a weed

            if(isActualSquareATree()){
                updatePositionLeavesTree();
            }else{
                if(isActualSquareAWeed()){
                    updatePositionInBoard();
//                    updatePositionWeed();
                    //Imagen de la weed:
                    this.previousSquareWasWeed = true;
                    this.bestFirstSearch();

                }
                else{
                    updatePositionInBoard();
                }
            }



        }

                      
    }

    public synchronized void updatePositionInBoard() {
        actualSquareInBoard = board[positionYAgent][positionXAgent];

        //System.out.println("Row: " + i + " Col:"    + j);
        if(this.previousSquareWasTree) {
            previousSquareInBoard.setIcon(null); // Elimina su figura de la casilla anterior
            previousSquareInBoard.setIcon(treeIcon); // Elimina su figura de la casilla anterior
            actualSquareInBoard.setIcon(null);
            actualSquareInBoard.setIcon(iconAgent);
            this.previousSquareWasTree = false;

        }else if(this.previousSquareWasWeed) {
            if(weedCoordinates.get(auxCoordinatesWeed) <= 0.0){
                previousSquareInBoard.setIcon(null); // Elimina su figura de la casilla anterior
//                casillaActual.setIcon(icon); // Pone su figura en la nueva casilla
            }else if(weedCoordinates.get(auxCoordinatesWeed) <= 1.0){
                previousSquareInBoard.setIcon(weedOneIcon);
            }else{
                previousSquareInBoard.setIcon(weedTwoIcon);
            }
            this.previousSquareWasWeed = false;
        }else{


            previousSquareInBoard.setIcon(null); // Elimina su figura de la casilla anterior
            actualSquareInBoard.setIcon(iconAgent); // Pone su figura en la nueva casilla

        }
        sleep();

    }

    public synchronized void updatePositionLeavesTree() {
        actualSquareInBoard = board[positionYAgent][positionXAgent];


        previousSquareInBoard.setIcon(null); // Elimina su figura de la casilla anterior
        actualSquareInBoard.setIcon(null);
        if(this.gotWeed){
            actualSquareInBoard.setIcon(smokeIcon);
            this.gotWeed = false;
            try
            {
                sleep(500+ random.nextInt(1));
            }
            catch (Exception ex)
            {
                ex.printStackTrace();
            }
        }else{
            actualSquareInBoard.setIcon(treeIcon);
        }
        this.previousSquareWasTree = true;

        //System.out.println("Row: " + i + " Col:"    + j);
        sleep();

    }

    public synchronized void updatePositionWeed() {
        actualSquareInBoard = board[positionYAgent][positionXAgent];

        //System.out.println("Row: " + i + " Col:"    + j);


        previousSquareInBoard.setIcon(null); // Elimina su figura de la casilla anterior
        actualSquareInBoard.setIcon(iconAgent); // Pone su figura en la nueva casilla

        sleep();

    }

    public synchronized boolean iAmInATree(ArrayList<Integer> treeCoordinates){
        int coordinateYOfTree = treeCoordinates.get(1);
        int coordinateXOfTree = treeCoordinates.get(0);
        if(positionYAgent == coordinateYOfTree && positionXAgent == coordinateXOfTree){
            return true;
        }else{
            return false;
        }

    }
    public synchronized void bestFirstSearch(){
        double actual_distance = 0;
        double next_distance = 0;
        int aux_x =0;
        int aux_y = 0;

        ArrayList<Integer> treeCoordinates = this.findNearestTreeCoordinates();
        System.out.println("=======================================: ");
        ArrayList<Integer> dirCol_dirRow = this.move2aNewPosition();



        while (!iAmInATree(treeCoordinates)){
//            System.out.println("NAVE MAS CERCA: "+ treeCoordinates);
            aux_x = positionXAgent - treeCoordinates.get(0);
            aux_y = positionYAgent - treeCoordinates.get(1);
            actual_distance = Math.sqrt(Math.pow((aux_x),2) + Math.pow((aux_y),2));
            System.out.println("Distancia: "+ actual_distance);

            // MOVE for next
            dirCol_dirRow = this.move2aNewPosition();
            aux_y= positionYAgent +dirCol_dirRow.get(0)- treeCoordinates.get(1);
            aux_x= positionXAgent +dirCol_dirRow.get(1) - treeCoordinates.get(0);


            //Add position

            next_distance = Math.sqrt(Math.pow((aux_x),2) + Math.pow((aux_y),2));
            System.out.println("Distancia Sig: "+ next_distance);

            if (next_distance <= actual_distance + 0.3){
                previousSquareInBoard = board[positionYAgent][positionXAgent];
                positionYAgent = positionYAgent +dirCol_dirRow.get(0);
                positionXAgent = positionXAgent +dirCol_dirRow.get(1);


                if(isActualSquareATree()){
                    updatePositionLeavesTree();
                }else{

                    updatePositionInBoard();
                }

            }

        }
        System.out.println("---------SIUUUUU----------");



    }
    public synchronized ArrayList<Integer> findNearestTreeCoordinates(){
        ArrayList<Integer> treeNearestCoordinates = new ArrayList<Integer>();
        double distance2Tree = 0;
        double shortestDistance2Tree = 100000000;
        int treeXCoordinate = 0;
        int treeYCoordinate = 0;

        int positionY = 1;
        int positionX = 0;

        System.out.println("COORDENADAS TREEE--"+ treeCoordinates);
        for (ArrayList<Integer> treeCoordinate: treeCoordinates.keySet()) {
            int aux4CalculatingDistanceX = positionXAgent - treeCoordinate.get(positionX);
            int aux4CalculatingDistanceY = positionYAgent - treeCoordinate.get(positionY);
            distance2Tree = Math.sqrt(Math.pow((aux4CalculatingDistanceX),2) + Math.pow((aux4CalculatingDistanceY),2));
            System.out.println(distance2Tree +" -- "+ shortestDistance2Tree);

            if (distance2Tree < shortestDistance2Tree){
                shortestDistance2Tree = distance2Tree;
                treeXCoordinate = treeCoordinate.get(positionX);
                treeYCoordinate = treeCoordinate.get(positionY);
            }

        }
        treeNearestCoordinates.add(treeXCoordinate);
        treeNearestCoordinates.add(treeYCoordinate);
        System.out.println(treeNearestCoordinates);
        return treeNearestCoordinates;
    }


    public synchronized ArrayList<Integer> move2aNewPosition(){

        ArrayList<Integer> nextYPosition_nextXPosition = this.randomNewPosition();
        int newYPosition = nextYPosition_nextXPosition.get(0);
        int newXPosition = nextYPosition_nextXPosition.get(1);
        int sizeOfBoard = matrix.length-1;
//        Delimitation the agent position to the board
//        Also checking that we are not in a cop
        int nextXPosition = positionXAgent + newXPosition;
        int nextYPosition = positionYAgent + newYPosition;
        while(nextYPosition > sizeOfBoard || nextYPosition < 0 || nextXPosition > sizeOfBoard || nextXPosition < 0 || isNextSquareACop(nextYPosition, nextXPosition)){

//            Finding new positions to X and Y
            nextYPosition_nextXPosition = this.randomNewPosition();
            newYPosition = nextYPosition_nextXPosition.get(0);
            newXPosition = nextYPosition_nextXPosition.get(1);

//            Adding those position to think about the next position
            nextXPosition = positionXAgent + newXPosition;
            nextYPosition = positionYAgent + newYPosition;
        }
        return nextYPosition_nextXPosition;
    }

    public synchronized ArrayList<Integer> randomNewPosition(){
        //        Y = i / X = j
//        DirCol / DirRow
        int[] moveNorth ={ 1, 0} ;
        int[] moveSouth = {-1, 0};
        int[] moveEast = {0,1};
        int[] moveWeast = {0,-1};
        ArrayList<Integer> newY_newX = new ArrayList<Integer>();

        int random = this.random.nextInt(0, 4);
        switch (random) {
            case 0:
                newY_newX.add(moveNorth[0]);
                newY_newX.add(moveNorth[1]);
                break;
            case 1:
                newY_newX.add(moveSouth[0]);
                newY_newX.add(moveSouth[1]);
                break;
            case 2:
                newY_newX.add(moveEast[0]);
                newY_newX.add(moveEast[1]);
                break;
            case 3:
                newY_newX.add(moveWeast[0]);
                newY_newX.add(moveWeast[1]);
                break;
        }
        return newY_newX;

    }

    public synchronized boolean isNextSquareACop(int nextYPosition, int nextXPosition) {
        int positionY = 1;
        int positionX = 0;
        for (ArrayList<Integer> copCoordinate: copCoordinates.keySet()) {
            if(copCoordinate.get(positionY) == nextYPosition && copCoordinate.get(positionX) == nextXPosition){
                return true;
            }
        }
        return false;
    }

    public synchronized boolean isActualSquareAWeed(){
//        i = y
        int positionY = 1;
        int positionX = 0;
//        Iterating through all the hash map
        for (ArrayList<Integer> weedCoordinateInHashMap: weedCoordinates.keySet()) {
//            System.out.println("Coordenada en hash = "+ coordinatesInHashMap + "-- nuevas: "+ coordinates)
//            Checking if actual position is a coordinate in weed coordinates
            if(weedCoordinateInHashMap.get(positionY) == positionYAgent && weedCoordinateInHashMap.get(positionX) == positionXAgent){
//              Also checking if there is still some weed in that square
                Double weedsLeftOver = weedCoordinates.get(weedCoordinateInHashMap);

                if(weedsLeftOver > 0.0){
//                    Eliminating a weed in that square
                    weedCoordinates.put(weedCoordinateInHashMap, weedsLeftOver- 1.0);
//                    System.out.println("AGARRALA GORDOOOOOOOOOOO");
//                    System.out.println(weedCoordinates);

//                    Taking the actual coordinates of the weed
                    this.auxCoordinatesWeed = weedCoordinateInHashMap;
//                    So you have one weed in your hands
                    this.gotWeed = true;
                    return true;
                }else{
                    System.out.println("Shit theres is no more weed here");
                }
            }
        }
        return false;

    }
    public synchronized boolean isActualSquareATree(){
        int positionY = 1;
        int positionX = 0;
        for (ArrayList<Integer> treeCoordinate: treeCoordinates.keySet()) {
            if(treeCoordinate.get(positionY) == positionYAgent && treeCoordinate.get(positionX) == positionXAgent){
                return true;
            }
        }
        return false;
    }
    public synchronized void sleep(){
        try
        {
            sleep(100+ random.nextInt(1));
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }


    }
    
    
}
