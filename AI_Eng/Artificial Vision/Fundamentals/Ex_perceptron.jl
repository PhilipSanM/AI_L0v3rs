using PlotlyJS, Statistics

# Mahalanobis x::vector desconocido, m::vector medias, mcov::matriz de covarianza 
distancia(x,m,mcov) = sqrt((x-m')*mcov*(x-m')')

graficar(x,y,z,color,nombre,modo) = scatter3d(
                                            x=x, y=y, z=z, 
                                            color=color, 
                                            name=nombre, 
                                            mode=modo)

                        
function main()
    #Cordenadas clase 1
    cords_c1 = [0 1 1 1;
                0 0 0 1;
                0 0 1 0]
    #Cordenadas clase 2
    cords_c2 = [0 0 1 0;
                0 1 1 1;
                1 1 1 0]

    c1 = []
    for i in 1:size(cords_c1)[2]
        push!(c1, cords_c1[:,i])
    end
    c2 = []
    for i in 1:size(cords_c2)[2]
        push!(c2, cords_c2[:,i])
    end


    layout = Layout(title="Scatter Plot")
    trace1 = graficar(cords_c1[1,:], cords_c1[2,:], cords_c1[3,:], :red3, "Class 1", "markers+lines")
    trace2 = graficar(cords_c2[1,:], cords_c2[2,:], cords_c2[3,:], :blue, "Class 2", "markers+lines" )

    while true
        println("Enter values: w1 w2 w3 w0 x0 r")
        punto = readline()
        p_cords = parse.(Float64, split(punto, " ", limit=6))'

        weights = [p_cords[1], p_cords[2], p_cords[3], p_cords[4]]
        x0 = p_cords[5]
        r = p_cords[6]

        result_weights, cicles = perceptron(c1, c2, 0, 0, x0, weights, 1000000, r)
        
        println("\n\nResult weights: ", result_weights)
        println("Cicles: ", cicles)

        # Plot of plane  
        # f = x1w1 + x2w2 + x3w3 + x0w0
        # x3 = -x1w1 - x2w2 - xow0 / w3
\

       
        x_values = LinRange(-1.3, 1.3, 10)
        y_values = LinRange(-1.3, 1.3, 10)
        
        
        z_values = zeros(10, 10)
        
        for i in 1:10
            for j in 1:10
                z_values[i, j] = (-result_weights[1] * x_values[i] - result_weights[2] * y_values[j] - result_weights[4]* x0) / result_weights[3]
            end
        end
        
       
        trace3 = surface(x=x_values, y=y_values, z=z_values, colorscale="Viridis", reversescale=true)
        


        display(plot([trace1, trace2, trace3], layout))
        

        println("\n\nSi deseas salir del programas ingresa 'q' ");
        input = readline(stdin);
        if input == "q"
            break
        end  
    end

end

function perceptron(c1, c2, rule_c1, rule_c2, x0, weights, max_cicles, r)
    cicles = 1
    result_weights = weights
    while true
        contin = false

        for class in c1
            aux = []
            for variable in class
                push!(aux, variable)
            end
            push!(aux, x0)

            out_function = aux' * result_weights

            if out_function >= rule_c1
                result_weights = result_weights - r .* aux
                contin = true
            end
        end

        for weight in c2
            aux = []
            for class in weight
                push!(aux, class)
            end
            push!(aux, x0)
            out_function = aux' * result_weights

            if out_function <= rule_c2                
                result_weights = result_weights + r * aux
                contin = true
            end
        end

        if contin == true && cicles < max_cicles
            cicles = cicles + 1
        else
            break
        end
    end
    
    return result_weights, cicles
end