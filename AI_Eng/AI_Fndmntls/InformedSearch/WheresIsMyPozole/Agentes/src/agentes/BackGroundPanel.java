/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package agentes;

import java.awt.Dimension;
import java.awt.Graphics;
import javax.swing.ImageIcon;
import javax.swing.JPanel;

/**
 *
 * @author macario
 */
public class BackGroundPanel extends JPanel
{
    
    ImageIcon backGround;
    
    public BackGroundPanel(ImageIcon backGround)
    {
        super();
        this.backGround = backGround;
        repaint();
    }
    
    @Override
    public void paintComponent(Graphics g)
    {
        Dimension dim = this.getSize();
        int ancho = (int) dim.getWidth();
        int alto  = (int) dim.getHeight();
        g.drawImage(backGround.getImage(), 0, 0, ancho, alto, null);
        setOpaque(false);
        super.paintComponent(g);
    }
    
}
