/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package agentes;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ItemEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JRadioButtonMenuItem;

/**
 *
 * @author macario
 */
public class Escenario extends JFrame
{

    
    private JLabel[][] board;
    private int[][] matrix;
    private final int dim = 15;

    private ImageIcon brandomIcon;
    private ImageIcon emiIcon;
    private ImageIcon obstacleIcon;
    private ImageIcon weedOneIcon;
    private ImageIcon weedTwoIcon;
    private ImageIcon weedThreeIcon;
    private ImageIcon actualIcon;
    private ImageIcon treeIcon;

    private ImageIcon smokeIcon;
    
    private Agente brandom;
    private Agente emi;

    HashMap<ArrayList<Integer>,Double> weedCoordinates = new HashMap<ArrayList<Integer>, Double>();
    HashMap<ArrayList<Integer>,Double> treeCoordinates = new HashMap<ArrayList<Integer>, Double>();
    HashMap<ArrayList<Integer>,Double> copCoordinates = new HashMap<ArrayList<Integer>, Double>();

    HashMap<ArrayList<Integer>,Double> crumbCoordinates = new HashMap<ArrayList<Integer>, Double>();

    private final BackGroundPanel backGroundPanel = new BackGroundPanel(new ImageIcon("imagenes/scene.png"));
    private final JMenu settings = new JMenu("Settings"); //Parte 1 del menu
    private final JRadioButtonMenuItem copMenuItem = new JRadioButtonMenuItem("Cop");
    private final JRadioButtonMenuItem weedMenuItem = new JRadioButtonMenuItem("Weed");
    private final JRadioButtonMenuItem treeMenuItem = new JRadioButtonMenuItem("Tree");
    
    public Escenario()
    {
        this.setContentPane(backGroundPanel);
        this.setTitle("Agents");
        this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        this.setBounds(50,50,dim*50+35,dim*50+85);
        initComponents();
    }
        
    public void initComponents() {
//        INIT OF THE BACKGROUN

        ButtonGroup settingsOptions = new ButtonGroup();
        settingsOptions.add(weedMenuItem);
        settingsOptions.add(copMenuItem);
        settingsOptions.add(treeMenuItem);
        
        JMenuBar barraMenus = new JMenuBar();
        JMenu file = new JMenu("File");
        JMenuItem run  = new JMenuItem("Run");

        JMenuItem exit   = new JMenuItem("Exit");
              
        this.setJMenuBar(barraMenus);
        barraMenus.add(file);
        barraMenus.add(settings);
        file.add(run);
        file.add(exit);
        settings.add(treeMenuItem);
        settings.add(copMenuItem);
        settings.add(weedMenuItem);
            
        brandomIcon = new ImageIcon("imagenes/persona1.png");
        brandomIcon = new ImageIcon(brandomIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        
        emiIcon = new ImageIcon("imagenes/persona2.png");
        emiIcon = new ImageIcon(emiIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        
        obstacleIcon = new ImageIcon("imagenes/cop.png");
        obstacleIcon = new ImageIcon(obstacleIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        
        weedOneIcon = new ImageIcon("imagenes/hemp.png");
        weedOneIcon = new ImageIcon(weedOneIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));

        weedTwoIcon = new ImageIcon("imagenes/2plantas.png");
        weedTwoIcon = new ImageIcon(weedTwoIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));

        weedThreeIcon = new ImageIcon("imagenes/3plantas.png");
        weedThreeIcon = new ImageIcon(weedThreeIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));

        treeIcon = new ImageIcon("imagenes/tree.png");
        treeIcon = new ImageIcon(treeIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        //Added 06/03/2023
        smokeIcon = new ImageIcon("imagenes/smoke.png");
        smokeIcon = new ImageIcon(smokeIcon.getImage().getScaledInstance(50,50,  java.awt.Image.SCALE_SMOOTH));
        
        this.setLayout(null);
        makeBoard();
        
        exit.addActionListener(evt -> exitHandler(evt));
        run.addActionListener(evt -> runHandler(evt));
        copMenuItem.addItemListener(evt -> copManage(evt));
        weedMenuItem.addItemListener(evt -> weedManage(evt));
        treeMenuItem.addItemListener(evt -> treeManage(evt));

              
            
        class MyWindowAdapter extends WindowAdapter
        {
            public void windowClosing(WindowEvent eventObject)
            {
		goodBye();
            }
        }
        addWindowListener(new MyWindowAdapter());
        

        brandom = new Agente("Brandom", brandomIcon, matrix, board, treeCoordinates, weedCoordinates, copCoordinates, crumbCoordinates);
        emi = new Agente("Emi", emiIcon, matrix, board, treeCoordinates, weedCoordinates, copCoordinates, crumbCoordinates);


        
    }
        
    private void exitHandler(ActionEvent eventObject)
    {
        goodBye();
    }

    private void goodBye()
    {
        System.exit(0);
    }

    private void makeBoard()
    {
        board = new JLabel[dim][dim];
        matrix = new int[dim][dim];
        
        int i, j;
        
        for(i=0;i<dim;i++)
            for(j=0;j<dim;j++)
            {
                matrix[i][j]=0;
                board[i][j]=new JLabel();
                board[i][j].setBounds(j*50+10,i*50+10,50,50);
                board[i][j].setBorder(BorderFactory.createDashedBorder(Color.white));
                board[i][j].setOpaque(false);
                this.add(board[i][j]);
                
                board[i][j].addMouseListener(new MouseAdapter() // Este listener nos ayuda a agregar poner objetos en la rejilla
                    {
                        @Override
                        public void mousePressed(MouseEvent e) 
                        {
                               insertObject(e);

                        }   
                
                        @Override
                        public void mouseReleased(MouseEvent e) 
                        {
                                insertObject(e);
                        }   
                
                    });
                                
            }
    }


        
    private void copManage(ItemEvent eventObject)
    {
        JRadioButtonMenuItem opt = (JRadioButtonMenuItem) eventObject.getSource();
        if(opt.isSelected()) {
            actualIcon = obstacleIcon;
        }
        else actualIcon = null;
    }
    private void weedManage(ItemEvent eventObject)
    {
        JRadioButtonMenuItem opt = (JRadioButtonMenuItem) eventObject.getSource();
        if(opt.isSelected())
           actualIcon = weedOneIcon;
        else actualIcon = null;   
    }
    private void treeManage(ItemEvent eventObject)
    {
        JRadioButtonMenuItem opt = (JRadioButtonMenuItem) eventObject.getSource();
        if(opt.isSelected())
           actualIcon = treeIcon;
        else actualIcon = null;   
    }
    private void runHandler(ActionEvent eventObject)
    {

        System.out.println("ARREGLO DE MARIS ======");
        System.out.println(weedCoordinates);
        System.out.println("ARREGLO DE TREES ======");
        System.out.println(treeCoordinates);
        System.out.println("ARREGLO DE Cops ======");
        System.out.println(copCoordinates);




        if(!brandom.isAlive()) brandom.start();
        if(!emi.isAlive()) emi.start();
        settings.setEnabled(false);
    }
       
    public void insertObject(MouseEvent e) {
        JLabel squareInBoard = (JLabel) e.getSource();

        if(actualIcon!=null) squareInBoard.setIcon(actualIcon);
        ArrayList coordinatesOfObject = new ArrayList<Integer>();
        int coordinateXOfObject = mappingFromEscene(squareInBoard.getX());
        int coordinateYOfObject = mappingFromEscene(squareInBoard.getY());
        coordinatesOfObject.add(coordinateXOfObject);
        coordinatesOfObject.add(coordinateYOfObject);
        if(actualIcon == treeIcon){
//            System.out.println("has puesto un spot");
            addingElementToHashMap(treeCoordinates,coordinatesOfObject,squareInBoard,false);
            System.out.println(treeCoordinates);

        }

        if (actualIcon == obstacleIcon){
//            System.out.println("has puesto un puerco");
            addingElementToHashMap(copCoordinates,coordinatesOfObject,squareInBoard,false);

        }
        if (actualIcon == weedOneIcon){
//            System.out.println("has puesto una mariwana");
            addingElementToHashMap(weedCoordinates,coordinatesOfObject,squareInBoard,true);

        }
    }

    private int mappingFromEscene(Integer x){
        if (x > 10){
            return (x - 10) / 50;
        }else{
            return x - 10;
        }
    }



    private boolean checkIfItIsAlreadyInHashMap(HashMap<ArrayList<Integer>, Double> hashMapCoordinates, ArrayList<Integer> coordinates){
        for (ArrayList<Integer> coordinatesInHashMap: hashMapCoordinates.keySet()) {
//            System.out.println("Coordenada en hash = "+ coordinatesInHashMap + "-- nuevas: "+ coordinates);
            if(coordinatesInHashMap.get(0) == coordinates.get(0) && coordinatesInHashMap.get(1) == coordinates.get(1)){
//                System.out.println("Ya estan ahi ");
                return true;
            }
        }
        return false;
    }



    private void addingElementToHashMap(HashMap<ArrayList<Integer>, Double> hashMapCoordinates, ArrayList<Integer> coordinates,JLabel squareInBoard,  boolean itsAWeed){

        if(checkIfItIsAlreadyInHashMap(hashMapCoordinates, coordinates)){
//                System.out.println("Ya estan ahi las coordenadas");
            hashMapCoordinates.put(coordinates, hashMapCoordinates.get(coordinates)+0.5);
            if(itsAWeed){
                // New sample icon
                if(hashMapCoordinates.get(coordinates) <= 1.0){
                    squareInBoard.setIcon(weedOneIcon);
                }else if (hashMapCoordinates.get(coordinates) > 1.0 && hashMapCoordinates.get(coordinates) <= 2.0){
                    squareInBoard.setIcon(weedTwoIcon);
                }else{
                    squareInBoard.setIcon(weedThreeIcon);
                }
            }
        }else{

            hashMapCoordinates.put(coordinates, 0.5);
        }

    }


}
