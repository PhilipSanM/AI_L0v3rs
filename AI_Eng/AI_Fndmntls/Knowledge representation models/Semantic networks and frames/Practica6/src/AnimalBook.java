import org.jpl7.*;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.*;
import java.util.Map;

public class AnimalBook extends JFrame {

//    Attributes of the GUI

    private ImageIcon animalIcon;
    private JLabel actualImage;
    private JTextField queryText;
    private JButton queryBotton;
    private JTextArea queryResult;

    public AnimalBook(){
        this.setSize(800, 800);
        this.getContentPane().setBackground(Color.WHITE);
        this.setTitle("Prolog frame in Java");
        animalIcon = new ImageIcon("images/animal_Icon.png");
        this.setIconImage(animalIcon.getImage());


        initComponents();
    }


    public void initComponents(){




        //Menu options
        setLayout(null);
        JMenuBar menu = new JMenuBar();
        setJMenuBar(menu);
        JMenu file=new JMenu("File");
        menu.add(file);
        JMenu settings=new JMenu("Settings");
        menu.add(settings);
        JMenu help=new JMenu("Help");
        menu.add(help);

        //Text field
        queryText = new JTextField(16);
        queryText.setBounds(30, 70, 200,25);
        this.add(queryText);

        //Button
        queryBotton = new JButton("Consultar");
        queryBotton.setBounds(30, 120, 200,25);
        queryBotton.setContentAreaFilled(false);
        this.add(queryBotton);


        //Result field
        queryResult = new JTextArea(10,10);
        queryResult.setBounds(30, 170, 200,300);
        this.add(queryResult);

        //image
        actualImage = new JLabel();
        actualImage.setIcon(new ImageIcon("images/nature.png"));
        actualImage.setBounds(300,120,300,300);
        this.add(actualImage);

        //        Prolog code
        String consultFile = "C:/Users/MrJel/Desktop/Felix/ESCOM/SEM_4/FUNDAMENTOS_DE_INTELIGENCIA_ARTIFICIAL/Pract6/Practica6/Practica6/src/data.pl";
        Query consultQuery = new Query("consult('" + consultFile + "')");
        if(consultQuery.hasSolution())System.out.println("Prolog file loaded...");

        queryBotton.addActionListener(evt -> makeQuery(evt));




        class MyWindowAdapter extends WindowAdapter
        {
            public void windowClosing(WindowEvent eventObject)
            {
                goodBye();
            }
        }
        addWindowListener(new MyWindowAdapter());


    }
    private void goodBye()
    {
        System.exit(0);
    }

    private void makeQuery(ActionEvent eventObject){
        queryResult.setText("");
        String prologQuery = queryText.getText();
        String filePath = "output.txt";


        try {
            // Crear un objeto FileOutputStream para el archivo de salida
            FileOutputStream fileOutput = new FileOutputStream(filePath);

            // Crear un objeto PrintStream para escribir en el archivo de salida
            PrintStream printStream = new PrintStream(fileOutput);

            // Redireccionar la salida estándar al archivo de salida
            System.setOut(printStream);

            // Imprimir algo en la salida estándar (que será redirigida al archivo de salida)
            System.out.println("Esta línea será escrita en sel archivo de salida.");

            // Configuración de JPL
            String[] jplArgs = { "-g", "true" }; // Opciones adicionales de JPL si es necesario
            JPL.init(jplArgs);

            // Consulta y redirige la salida de Prolog a fileStream
            Query query = new Query(prologQuery);
            query.open();
            while (query.hasMoreSolutions()) {
                java.util.Map<String, Term> solution = query.nextSolution();
                System.out.println(solution); // Imprime cada solución en el archivo
            }
            query.close();


            // Cerrar el archivo de salida
            printStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }


//        text

        String content = "";

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                content += line + "\n";
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        queryResult.append(content);




//      Colocating image:
        String delimiter = "[()]"; // Delimiter

        String[] parts = prologQuery.split(delimiter);

        String imageText = parts[1];

        System.out.println(imageText); // Output: gorilla_gorilla

        switch (imageText){
            case "gorilla_gorilla":
                actualImage.setIcon(new ImageIcon("images/gorilla.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "noctilio_albiventris":
                actualImage.setIcon(new ImageIcon("images/noctilio_albiventris.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "ailuropoda_melanoleuca":
                actualImage.setIcon(new ImageIcon("images/ailuropoda_melanoleuca.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "ursus_maritimus":
                actualImage.setIcon(new ImageIcon("images/ursus_maritimus.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "ceratotherium_simum":
                actualImage.setIcon(new ImageIcon("images/ceratotherium_simum.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "equus_caballus":
                actualImage.setIcon(new ImageIcon("images/equus_caballus.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "elephas_maximus":
                actualImage.setIcon(new ImageIcon("images/elephas_maximus.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "leopardus_geoffroyi":
                actualImage.setIcon(new ImageIcon("images/leopardus_geoffroyi.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;

            case "panthera_pardus":
                actualImage.setIcon(new ImageIcon("images/panthera_pardus.jpg"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;


            default:
                actualImage.setIcon(new ImageIcon("images/nature.png"));
                actualImage.setBounds(300,120,300,300);
                this.add(actualImage);
                break;



        }





    }

}
//    about(gorilla_gorilla).
