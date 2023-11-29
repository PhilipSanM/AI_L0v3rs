class pila(object):
    def __init__(self):
        self.pila = []
    def push(self, elemento):
        self.pila.append(elemento)
    def pop(self):
        return self.pila.pop()
    def peek(self):
        return self.pila[len(self.pila)-1]
    def size(self):
        return len(self.pila)
    def isEmpty(self):
        return self.pila == []
    

