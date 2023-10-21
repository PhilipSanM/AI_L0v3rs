graficar2d(x,y,nombre,modo,color) = scatter(x=x, y=y, name=nombre, mode=modo, color=color)


function main()
    x0 = 1
    r = 1
    c1 = [[1,0], [2,0]]
    c2 = [[-2,0], [-1,-2]]
    rule_c1 = 0
    rule_c2 = 0


    weights = [1,1,1]


    println("Enter values: w1 w2 w0 x0 r")
    punto = readline()
    p_cords = parse.(Float64, split(punto, " ", limit=6))'

    weights = [p_cords[1], p_cords[2], p_cords[3]]

    x0 = p_cords[4]

    r = p_cords[5]


    max_cicles = 1000
    result_weights, cicles = perceptron(c1, c2, rule_c1, rule_c2, x0, weights, max_cicles, r)


    println("Resultado de pesos: ",result_weights)
    println("Ciclos echos:", cicles)

    
  
    # Graficate in 2D
        # print ecuation
    println("Ecuacion: ", result_weights[1], "x1 + ", result_weights[2], "x2 + ", result_weights[3], " = 0")


    layout = Layout(title="Scatter Plot")


    trace1 = graficar2d([c1[1][1], c1[2][1]], [c1[1][2], c1[2][2]], "Class 1", "markers+lines", :red)
    trace2 = graficar2d([c2[1][1], c2[2][1]], [c2[1][2], c2[2][2]], "Class 2", "markers+lines", :green)

    x = range(-5, 5, length=100) # crea un rango de valores de x entre -5 y 5
    y = (-result_weights[1]*x .- result_weights[3]) / result_weights[2]
    
    trace3 = graficar2d(x,y, "ECUACION", "lines", :blue )
    plot([trace3, trace2, trace1], layout)




end


function perceptron(c1, c2, rule_c1, rule_c2, x0, weights, max_cicles, r)
    cicles = 1
    result_weights = weights
    while true
        println("------------------------------------------------")
        println("Cicle: ", cicles)
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

        println(result_weights)


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
        
        println(result_weights)

        if contin == true && cicles < max_cicles
            cicles = cicles + 1
        else
            break
        end
    end
    
    return result_weights, cicles
end

