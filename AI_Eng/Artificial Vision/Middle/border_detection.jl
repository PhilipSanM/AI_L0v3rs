#     INSTITUTO POLITÉCNICO NACIONAL
#     ESCUELA SUPERIOR DE COMPUTO
#     VISION ARTIFICIAL
#     DETECCION DE BORDES

using ImageMorphology, Images, ImageView
import Gtk4.open_dialog as dig

function erosion(A, Ω)
    out = similar(A)
    Ω = CartesianIndex.(findall(Ω))
    #Ω = strel(CartesianIndex, Ω)
    R = CartesianIndices(A)
    for p in R
        Ωₚ = filter!(q->in(q, R), Ref(p) .+ Ω)
        out[p] = max(A[p], maximum(A[Ωₚ]))
    end
    return out
end

function dilatacion(imagen::AbstractArray, elemento_estructurante::AbstractArray)
    filas, columnas = size(imagen) # tamaño de la imagen
    filas_ee, columnas_ee = size(elemento_estructurante)
    
    imagen_dilatada = zeros(filas,columnas)

    for i in 1:filas
        for j in 1:columnas
            if imagen[i, j] == 1
                for m in 1:filas_ee
                    for n in 1:columnas_ee
                        if i + m - 1 <= filas && j + n - 1 <= columnas && elemento_estructurante[m, n] == 1
                            imagen_dilatada[i + m - 1, j + n - 1] = 1
                        end
                    end
                end
            end
        end
    end

    return imagen_dilatada
end

# Structuring Elements
Ω_mask1 = Bool[0 0 0 0 0 ;0 0 1 0 0; 0 1 1 1 0; 0 0 1 0 0; 0 0 0 0 0] |> centered
Ω_mask2 = Bool[0 0 0 0 0 ;0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 0 0 0 0] |> centered
Ω_mask3 = Bool[0 1 1 1 0 ;1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0]|> centered
Ω_mask4 = Bool[0 0 0; 1 1 1; 0 0 0] |> centered

function main()
    img = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0;
       0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 0 0;
       0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 0;
       0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0;
       0 0 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0;
       0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 0 0;
       0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;

    ]
    plot = heatmap(img, color=:grays, aspect_ratio=:equal, yflip=true, legend=false, axis=false, grid=false, ticks=false, border=:none)
    display(plot)
    path = "./Examen.png"
    savefig(plot, path)

    while true
        # Load image
        # img = Gray.(imresize(load(path), (256, 256)))
        # # Binarize image
        # bin = @.Gray(img .> 0.5)
        # # Erode image and get complement
        # img_ec1 = erosion(bin, Ω_mask1)
        # img_ec2 = erosion(bin, Ω_mask2)
        # img_ec3 = erosion(bin, Ω_mask3)
        # img_ec4 = erosion(bin, Ω_mask4)
        # # AND between the binarize image and the output
        # img_b1 = bin .== img_ec1
        # img_b2 = bin .== img_ec2
        # img_b3 = bin .== img_ec3
        # img_b4 = bin .== img_ec4
        # # Show output
        # imshow(mosaicview(bin, erosion(bin, Ω_mask1), erosion(bin, Ω_mask2), erosion(bin, Ω_mask3), img_b4; nrow=1))



        Ω_mask1 = Bool[0 0 0 0 0; 0 0 1 0 0; 0 1 1 1 0; 0 0 1 0 0; 0 0 0 0 0] |> centered
        Ω_mask2 = Bool[0 0 0 0 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 0 0 0 0] |> centered
        Ω_mask3 = Bool[0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0] |> centered

        bin = Gray.(img)

        # Erode image and get complement
        img_ec1 = erosion(bin, Ω_mask1)
        img_ec2 = erosion(bin, Ω_mask2)
        img_ec3 = erosion(bin, Ω_mask3)

        imshow(mosaicview(bin, img_ec1, img_ec2, img_ec3; nrow=1))


        # Ω_mask1 = Bool[0 0 0 0 0; 0 0 1 0 0; 0 1 1 1 0; 0 0 1 0 0; 0 0 0 0 0] |> centered
        # Ω_mask2 = Bool[0 0 0 0 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 0 0 0 0] |> centered
        # Ω_mask3 = Bool[0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0] |> centered

        # bin = Gray.(img)

        # # Erode image and get complement
        # img_ec1 = dilatacion(bin, Ω_mask1)
        # img_ec2 = dilatacion(bin, Ω_mask2)
        # img_ec3 = dilatacion(bin, Ω_mask3)

        # imshow(mosaicview(bin, img_ec1, img_ec2, img_ec3; nrow=1))

        println("\n\nSi deseas salir del programas ingresa 'q' ");
        input = readline(stdin);
        (input == "q") ? break : continue
    end
end