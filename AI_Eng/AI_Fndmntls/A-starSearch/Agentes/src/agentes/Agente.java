/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package agentes;

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
public class Agente extends Thread
{

    String nombre;
    ImageIcon motherIcon;
    ImageIcon smokeIcon;
    ImageIcon weedTwoIcon;
    ImageIcon weedOneIcon;
    ImageIcon weedTreeIcon;

    int i;
    int j;
    ImageIcon icon;
    int[][] matrix;
    JLabel tablero[][];
    
    JLabel casillaAnterior;
    JLabel casillaActual;
    boolean cop = false;
    boolean eraArbol = false;
    boolean trasMari = false;
    boolean wasWeed = false;





    Random aleatorio = new Random(System.currentTimeMillis());

    ArrayList coordenadasMotherShip = new ArrayList<Integer>();

    HashMap<ArrayList<Integer>,Double> weedCoordinates = new HashMap<ArrayList<Integer>, Double>();

    ArrayList coordenadasObstacle = new ArrayList<Integer>();

    ArrayList auxCoordinatesSample = new ArrayList<Integer>();


    
    public Agente(String nombre, ImageIcon icon, int[][] matrix, JLabel tablero[][], ArrayList<Integer> coordenadasMotherShip, HashMap<ArrayList<Integer>,Double> weedCoordinates , ArrayList<Integer> coordenadasObstacle)
    {
        this.nombre = nombre;
        this.icon = icon;
        this.matrix = matrix;
        this.tablero = tablero;
        this.coordenadasMotherShip = coordenadasMotherShip;
        this.coordenadasObstacle = coordenadasObstacle;
        this.weedCoordinates = weedCoordinates;


        
        this.i = aleatorio.nextInt(matrix.length);
        this.j = aleatorio.nextInt(matrix.length);
        tablero[i][j].setIcon(icon);
        motherIcon = new ImageIcon("imagenes/tree.png");
        motherIcon = new ImageIcon(motherIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        smokeIcon = new ImageIcon("imagenes/smoke.png");
        smokeIcon = new ImageIcon(smokeIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        weedOneIcon = new ImageIcon("imagenes/hemp.png");
        weedOneIcon = new ImageIcon(weedOneIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));

        weedTwoIcon = new ImageIcon("imagenes/2plantas.png");
        weedTwoIcon = new ImageIcon(weedTwoIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));

        weedTreeIcon = new ImageIcon("imagenes/3plantas.png");
        weedTreeIcon = new ImageIcon(weedTreeIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));

        this.eraArbol = false;
        this.trasMari = false;
        this.wasWeed = false;




    }




    public void run()
    {

        while(true) {
            //posicion de robots i,j, posicion obstacle
            casillaAnterior = tablero[i][j];
/*
                dirRow = aleatorio.nextInt(-1, 2); //only can move into -1 or 1
                dirCol = aleatorio.nextInt(-1, 2);

*/

            ArrayList<Integer> dirCol_dirRow = this.movimiento();


            //Add to the position
            i=i+dirCol_dirRow.get(0);
            j=j+dirCol_dirRow.get(1);



            if(sensorArbolMariwuano()){
                actualizarPosicionDejaArbol();
            }else{
                if(sensorMineral()){
                    actualizarPosicion();
//                    updatePositionWeed();
                    //Imagen de la weed:
                    this.wasWeed = true;
                    this.sensorGradiente();
                }
                else{
                    actualizarPosicion();
                }
            }

            //moneedita pasa esto
//            this.sensorGradiente();

        }

                      
    }

    public synchronized void actualizarPosicion() {
        casillaActual = tablero[i][j];

        //System.out.println("Row: " + i + " Col:"    + j);
        if(this.eraArbol) {
            casillaAnterior.setIcon(null); // Elimina su figura de la casilla anterior
            casillaAnterior.setIcon(motherIcon); // Elimina su figura de la casilla anterior
            casillaActual.setIcon(null);
            casillaActual.setIcon(icon);
            this.eraArbol = false;

        }else if(this.wasWeed) {
            if(weedCoordinates.get(auxCoordinatesSample) <= 0.0){
                casillaAnterior.setIcon(null); // Elimina su figura de la casilla anterior
//                casillaActual.setIcon(icon); // Pone su figura en la nueva casilla
            }else if(weedCoordinates.get(auxCoordinatesSample) <= 1.0){
                casillaAnterior.setIcon(weedOneIcon);
            }else{
                casillaAnterior.setIcon(weedTwoIcon);
            }
            this.wasWeed = false;
        }else{


            casillaAnterior.setIcon(null); // Elimina su figura de la casilla anterior
            casillaActual.setIcon(icon); // Pone su figura en la nueva casilla

        }
        sleep();

    }

    public synchronized void actualizarPosicionDejaArbol() {
        casillaActual = tablero[i][j];


        casillaAnterior.setIcon(null); // Elimina su figura de la casilla anterior
        casillaActual.setIcon(null);
        if(this.trasMari){
            casillaActual.setIcon(smokeIcon);
            this.trasMari= false;
            try
            {
                sleep(500+aleatorio.nextInt(1));
            }
            catch (Exception ex)
            {
                ex.printStackTrace();
            }
        }else{
            casillaActual.setIcon(motherIcon);
        }
        this.eraArbol = true;

        //System.out.println("Row: " + i + " Col:"    + j);
        sleep();

    }

    public synchronized void updatePositionWeed() {
        casillaActual = tablero[i][j];

        //System.out.println("Row: " + i + " Col:"    + j);


        casillaAnterior.setIcon(null); // Elimina su figura de la casilla anterior
        casillaActual.setIcon(icon); // Pone su figura en la nueva casilla

        sleep();

    }

    public synchronized boolean sensorNaveNodriza(ArrayList<Integer> coordenadasNave){
        if(i == coordenadasNave.get(1) && j == coordenadasNave.get(0)){
            return true;
        }else{
            return false;
        }

    }
    public synchronized void sensorGradiente(){
        double actual_distance = 0;
        double next_distance = 0;
        int aux_x =0;
        int aux_y = 0;

        ArrayList<Integer> coordenadasNave = this.naveMasCercana();
        System.out.println("=======================================: ");
        ArrayList<Integer> dirCol_dirRow = this.movimiento();



        while (!sensorNaveNodriza(coordenadasNave)){
            System.out.println("NAVE MAS CERCA: "+ coordenadasNave);
            aux_x = j - coordenadasNave.get(0);
            aux_y = i - coordenadasNave.get(1);
            actual_distance = Math.sqrt(Math.pow((aux_x),2) + Math.pow((aux_y),2));
            System.out.println("Distancia: "+ actual_distance);

            // MOVE for next
            dirCol_dirRow = this.movimiento();
            aux_y=i+dirCol_dirRow.get(0)- coordenadasNave.get(1);
            aux_x=j+dirCol_dirRow.get(1) - coordenadasNave.get(0);


            //Add position

            next_distance = Math.sqrt(Math.pow((aux_x),2) + Math.pow((aux_y),2));
            System.out.println("Distancia Sig: "+ next_distance);

            if (next_distance <= actual_distance + 0.3){
                casillaAnterior = tablero[i][j];
                i=i+dirCol_dirRow.get(0);
                j=j+dirCol_dirRow.get(1);


                if(sensorArbolMariwuano()){
                    actualizarPosicionDejaArbol();
                }else{

                    actualizarPosicion();
                }

            }

        }
        System.out.println("---------SIUUUUU----------");



    }
    public synchronized ArrayList<Integer> naveMasCercana(){
        ArrayList<Integer> coordenadas = new ArrayList<Integer>();
        double distance = 0;
        double low_distance = 1000000;
        int x = 0;
        int y = 0;
        for(int z = 0; z < this.coordenadasMotherShip.size(); z++){
            int aux_x = j - (int)this.coordenadasMotherShip.get(z);
            int aux_y = i - (int)this.coordenadasMotherShip.get(z+1);
            distance = Math.sqrt(Math.pow((aux_x),2) + Math.pow((aux_y),2));


            if (distance < low_distance){
                low_distance = distance;
                x = (int)this.coordenadasMotherShip.get(z);
                y = (int)this.coordenadasMotherShip.get(z+1);
            }
            z++;
        }
        coordenadas.add(x);
        coordenadas.add(y);
        return coordenadas;
    }


    public synchronized ArrayList<Integer> movimiento(){


        ArrayList<Integer> dirCol_dirRow = this.randomDir();

        while(i + dirCol_dirRow.get(0) > matrix.length-1 || i+ dirCol_dirRow.get(0) < 0 || j+ dirCol_dirRow.get(1) > matrix.length-1 || j+ + dirCol_dirRow.get(1) < 0 || esUnaCop(i + dirCol_dirRow.get(0), j+ dirCol_dirRow.get(1) ,"kk")){
            dirCol_dirRow = this.randomDir();
        }


        return dirCol_dirRow;

    }

    public synchronized ArrayList<Integer> randomDir(){
        //        Y = i / X = j
//        DirCol / DirRow
        int[] norte ={ 1, 0} ;
        int[] sur = {-1, 0};
        int[] este = {0,1};
        int[] oeste = {0,-1};
        ArrayList<Integer> dirCol_dirRow = new ArrayList<Integer>();

        int random = aleatorio.nextInt(0, 4);
        switch (random) {
            case 0:
                dirCol_dirRow.add(norte[0]);
                dirCol_dirRow.add(norte[1]);
                break;
            case 1:
                dirCol_dirRow.add(sur[0]);
                dirCol_dirRow.add(sur[1]);
                break;
            case 2:
                dirCol_dirRow.add(este[0]);
                dirCol_dirRow.add(este[1]);
                break;
            case 3:
                dirCol_dirRow.add(oeste[0]);
                dirCol_dirRow.add(oeste[1]);
                break;
        }
        return dirCol_dirRow;

    }

    public synchronized boolean esUnaCop(int i_new, int j_new, String sensor) {
        int a = 0;
        int b = 0;
        for (int recorrido = 0; recorrido < this.coordenadasObstacle.size(); recorrido++) { //Recorre todos los elementos
            a = (int) this.coordenadasObstacle.get(recorrido);
            b = (int) this.coordenadasObstacle.get(recorrido + 1);
            //System.out.println("ACTUAL DATA " + " (i,j) =  " + i_new + "," + j_new + " "+ "  a,b "+ a + "," + b);
            recorrido = recorrido + 1;
            if (b == i_new && a == j_new) {
                System.out.println("><<<<<<<<<<<<<<<<<<<" + sensor + "<<<<<<<<<<<<<<<<<<<<");
                System.out.println("CORRELE GORDOOOOOOOOOO CORRELE");
                return true;
            }
        }

        return false;
    }

    public synchronized boolean sensorMineral(){
//        i = y
        for (ArrayList<Integer> coordinatesInHashMap: weedCoordinates.keySet()) {
//            System.out.println("Coordenada en hash = "+ coordinatesInHashMap + "-- nuevas: "+ coordinates)
            if(coordinatesInHashMap.get(1) == i && coordinatesInHashMap.get(0) == j){

                if(weedCoordinates.get(coordinatesInHashMap) > 0.0){
                    //Eliminacion de mari
                    weedCoordinates.put(coordinatesInHashMap, weedCoordinates.get(coordinatesInHashMap)- 1.0);
                    System.out.println("AGARRALA GORDOOOOOOOOOOO");
                    System.out.println(weedCoordinates);
                    //Trae mari
                    this.auxCoordinatesSample = coordinatesInHashMap;
                    this.trasMari= true;

                    return true;
                }else{
                    System.out.println("Huevos me las acabe");
                }
            }
        }
        return false;

    }
    public synchronized boolean sensorArbolMariwuano(){
        int a = 0;
        int b = 0;

        for (int recorrido = 0; recorrido < this.coordenadasMotherShip.size(); recorrido++) { //Recorre todos los elementos
            a = (int) this.coordenadasMotherShip.get(recorrido);
            b = (int) this.coordenadasMotherShip.get(recorrido + 1);
            //System.out.println("ACTUAL DATA " + " (i,j) =  " + i_new + "," + j_new + " "+ "  a,b "+ a + "," + b);
            recorrido = recorrido + 1;
            if (b == i && a == j) {
                System.out.println("><<<<<<<<<<<<<<<<<<<"  + "<<<<<<<<<<<<<<<<<<<<");
                System.out.println("ARRBOOOOOOLLLLL");

                return true;
            }
        }
        return false;

    }
    public synchronized void sleep(){
        try
        {
            sleep(100+aleatorio.nextInt(1));
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }


    }
    
    
}
