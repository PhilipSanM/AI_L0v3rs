function main()
    x0 = 1
    r = 1
    c1 = [[0,0]]
    c2 = [[0,1], [1,0], [1,1]]
    weights = [1,1,1]
    rule_c1 = 0
    rule_c2 = 0
    max_cicles = 1000
    result_weights, cicles = perceptron_recursive(c1, c2, rule_c1, rule_c2, x0, weights, max_cicles, r, 1)
    println(result_weights)
    println(cicles)
end


function perceptron(c1, c2, rule_c1, rule_c2, x0, weights, max_cicles, r)
    cicles = 1
    result_weights = weights
    while true
        contin = false
        for weight in c1
            x1 = weight[1]
            x2 = weight[2]
            aux = [ x1, x2, x0]

            out_function = aux' * result_weights

            if out_function >= rule_c1
                result_weights = result_weights - r .* aux
                contin = true
            end
        end

        for weight in c2
            x1 = weight[1]
            x2 = weight[2]
            aux = [ x1, x2, x0]
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


function perceptron_recursive(c1, c2, rule_c1, rule_c2, x0, weights, max_cicles, r, cicles)
    contin = false
    result_weights = weights
    for weight in c1
        x1 = weight[1]
        x2 = weight[2]
        aux = [ x1, x2, x0]

        out_function = aux' * result_weights

        if out_function >= rule_c1
            result_weights = result_weights - r * aux
            contin = true
        end
    end

    for weight in c2
        x1 = weight[1]
        x2 = weight[2]
        aux = [ x1, x2, x0]
        out_function = aux' * result_weights

        if out_function <= rule_c2                
            result_weights = result_weights + r * aux
            contin = true
        end
    end

    if contin && cicles < max_cicles
        return perceptron_recursive(c1, c2, rule_c1, rule_c2, x0, result_weights, max_cicles, r, cicles + 1)
    else
        return result_weights, cicles
    end
end