# 1-------------------------------------------------------------------------------------------------
# Pregunta 1: Leer las imágenes de image_directory y guardarlas en X (formato array). Visualizar
# y adjuntar la imágen asignada.

# Parámetros que se nos dans en el INTENTO 1 de la Práctica.
I <- 2
E <- 60
P <- 1
N <- 40 #Primera dimensión
R <- 56 #Segunda dimensión
C <- 46 #Tercera dimensión

# Función de visualización de imágenes
plt_img <- function(I){
  y <- 10*(1:nrow(I))
  x <- 10*(1:ncol(I))
  image(x, y, t(apply(I, 2, rev)), col=grey(seq(0, 1, length=256)), axes=FALSE,
        asp=1, xlab='', ylab='')
}

# Instalación packages recomendados
# install.packages("OpenImageR")
# install.packages("ramify")

# Importación de las librerías instaladas
library(OpenImageR)
library(ramify)

# Directorio que contiene las imágenes originales
image_directory <- "C:/Users/maite/Desktop/DATASCIENCE_1/Algebra Lineal - SEGUNDO INTENTO/PEC4/Práctica_1_Reconocimiento_Facial - Maite Lizarraga/images/"

# Lectura y guardado en array de las imágenes originales
setwd(image_directory)
Files <- list.files()
Results <- list()
for (i in seq_along(Files)){
  Image <- readImage(Files[i])
  Results[[i]] <- Image
}
X <- array(as.numeric(unlist(Results)), dim=c(N, R, C))

# Transformación del array X en vector para poder operar con él (X_vector).
# Transformación de este mismo vector en matriz para poder mostrar las imágenes (X_matrix).
X_vector <- resize(X, nrow=N, ncol=R*C, byrow=TRUE)
X_matrix <- resize(X_vector, N, R, C, byrow=FALSE)

# Dos formas de mostrar mi cara: 
# 1. accediendo al índice igual al número de mi cara en la lista de Results:
plt_img(Results[[I]])
# 2. accediendo a la primera dimensión de la matriz tridimensional resultante de la tranformación 
# del array X y vector X_vector:
plt_img(X_matrix[2,,])

# Control de valores NA y elementos vacíos por si los hubiera (no es el caso)
# X_matrix[!is.finite(X_matrix)] <- NA


# 2-------------------------------------------------------------------------------------------------
# 2.1 Cálculo de la media y de la desviación estándar (variables X_mean y X_std). Visualizar y 
# adjuntar la “cara media” y la “cara desviación típica”.

  # El cálculo de la media y la desviación típica de las caras nos permite normalizar cada elemento 
  # de forma que obtenemos la matriz centrada, aunque en este caso no vamos a realizar el cálculo 
  # uno a uno ya que disponemos de la función scale que nos lo hace automáticamente.

# CARA MEDIA (la media de todas las caras)
X_mean <- colMeans(X_matrix, dims=1)
plt_img(X_mean)

# CARA DESVIACIÓN ESTÁNDAR (la desviación estándar de todas las caras)
X_std <- apply(X_matrix, c(2,3), sd)
plt_img(X_std)

# 2.2 Normalizar los datos (variable Xs). Calcular y escribir la media de la imagen normalizada.
# Según lo dicho anteriormente, normalizamos los datos mediante la función scale ya que esta con-
# tiene los parámetros center y scale, que contienen la media aritmética y la desviación estándar
# respectivamente.Si quisiéramos hacerlo a mano, tendríamos que realizar la operación siguiente:
# valor del elemento menos la media, y ello dividido por la desviación estándar.
Xs<-scale(X_vector,center = TRUE,scale = TRUE)

# Media de la imagen normalizada correspondiente a la persona I
Xs_mean <- mean(Xs[2,])
# Xs_std <- sd(Xs[2,])

# 2.3 Calcular la matriz de covarianzas de los datos normalizados CXs. La matriz de covarianzas
# es simétrica y mide el grado de relación lineal del conjunto de datos entre cada uno de los 
# pares de variables. En este caso utilizo la funcíon cov() para el cálculo de esta matriz, ya que es
# mucho más sencillo.
CXs <- cov(Xs)

# Los términos de la diagonal principal corresponden a la varianza de cada una de las variables,
# aunque como nosotros le estamos pasando datos normalizados, la diagonal es 1. El resto de datos,
# los que no están en la diagonal principal, corresponden a las covarianzas entre pares de datos.

# 3-------------------------------------------------------------------------------------------------
# PCA Análisis de Componentes Principales. 

# 3.1 Calcular PCA de la matriz de covarianzas CXs mediante eigen. 

# Como bien dice el enunciado, este algoritmo nos proporciona los valores y vectores propios. 
# Sabemos por la teoría que estos datos constituyen los componentes principales y, debido a las
# características de la matriz de covarianzas (simétrica y positiva), todos los valores propios son
# positivos.
eigCXs<-eigen(CXs)

# 3.2 Calcular y escribir el VAP asociado a la componente principal P.
# Cálculo del valor propio asociado a la componente principal P. Los componentes principales se 
# muestran ordenados descendentemente, de mayor a menor, representando el peso de cada uno de ellos
# en la composición total (100%). Es decir, los valores propios, sumados, dan siempre 100.
P = 1
eigenvalues <- eigCXs$values
valor_propio_asociado_a_P = round(eigenvalues[P],2)

  # sum(eigCXs$values)
  # sum(eigCXs$vectors)
  # length(range(1:47))
  # length(ejeY_P)
  # length(eigCXs$values)http://127.0.0.1:22585/graphics/plot_zoom_png?width=1903&height=984
  # is.numeric(ejeY_P)
  # is.numeric(length(eigCXs$values))

# 3.3 Dibujar y adjuntar la distribución de la varianza acumulada (eje Y) para cada 
# componente principal (eje X) respecto a la varianza total de los datos. 

# Guardamos los vectores propios en su propia variable.
eigenvectors <- eigCXs$vectors

# Realizamos un bucle para calcular la varianza acumulada. En el caso de los eigenvalores, estos
# representan la varianza, por lo tanto, Vamos sumando los valores propios en cada iteración para.
# obtener la varianza acumulada. Hay que dejarlo actuar hasta que recorra los 2576 valores propios 
# que hay, por lo que tarda un rato. 
ejeY_P <- list()
for (i in seq_along(eigCXs$values)){
  if (i==1){
    ejeY_P[i] <- as.numeric(eigCXs$values[i]*100/sum(eigCXs$values))    
  }
  else {
    ejeY_P[i] <- as.numeric(ejeY_P[i-1]) + as.numeric(eigCXs$values[i]*100/sum(eigCXs$values))
    if (i==2756) {
      break
    }
  }
  print(ejeY_P)
}

# Una vez guardada la varianza acumulada en la variable ejeY_P, pasamos a realizar un gráfico. 
# Vemos en él que los 35 primeros componentes principales son los que más varianza absorben, mientras
# que el resto son casi irrelevantes.

# print(1:length(eigCXs$values))
ejeY_P <- as.numeric(ejeY_P)

plot((1:length(eigCXs$values)),ejeY_P, xlim=c(eigCXs$values.min,eigCXs$values.max), col = "blue", 
     pch = 19, lty = 3, xaxt = "n", yaxt="n", xlab="Componentes Principales", ylab="Varianza Acumulada")
lines((1:length(eigCXs$values)), ejeY_P, col = "lightblue")
axis(side = 1, at = seq(1, 46, by = 1), cex.axis = 0.75)
axis(side = 2, at = seq(10,100, by = 5), cex.axis = 0.75)
title(main="Distribución de la varianza acumulada para cada componente prinicipal respecto a la varianza total de los datos", 
      col.main="blue", cex.main="1")


# 4-------------------------------------------------------------------------------------------------
# 4.1 Visualizar y adjuntar la cara propia P (el valor propio asociado a la componente principal P). 

# El objetivo de la PCA es encontrar una transformación lineal (una aplicación lineal) tal que los 
# datos originales (X_vector) se transformen o se proyecten en un nuevo espacio mediante el producto 
# T = XP de forma que la matriz de covarianzas Cx de los nuevos datos sea diagonal.

# Lo primero que hacemos es asociar a la variable P la matriz de vectores propios, ya que esta matriz
# constituye nuestra P o aplicación lineal.
P <- eigCXs$vectors

# Y después calculamos las coordenadas de los datos originales en el espacio vectorial generado.
T <- X_vector%*%P

    # Sólo para mi Imagen
      # T <- Results[[I]]%*%P
      # Imagen_reconstruida <- T %*% t(eigCXs$vectors)
      # plt_img(Imagen_reconstruida)

# Visualizar la cara propia P mediante los eigenvectores asociados al eigenvalor de P
# for (i in I){
  # plt_img(matrix(as.numeric(P[,i]),nrow=56,byrow=F))
# }

plt_img(matrix(as.numeric(P[,2]),nrow=56,byrow=F))

    # Sólo para mi Imagen
    # plt_img(P)

# 4.2 Calcular y escribir la suma de todos los coeficientes de la cara propia P.
suma_first_component = sum(P[,1])


# 5-------------------------------------------------------------------------------------------------
# E% de la varianza total de los datos. ¿Cuántas componentes principales o “caras propias” (L) 
# se necesitan, como mínimo, para explicar un E% de la varianza total de los datos?

# Lo que se nos está pidiendo aquí es que comencemos a reducir la dimensionalidad, ya que ese es el
# objetivo principal de la PCA. Por ello, vamos a considerar un L, menor que los m eigenvalores o 
# valores propios, que nos puedan proporcionar una aproximación lo suficientemente buena a la calidad
# de imagen inicial con un peso mucho menor. Es decir, sólo seleccionamos los L vectoresmás grandes.
# Nos quedamos con E% de la varianza total de los datos (60%), buscamos el primer valor que supera ese
# 60% (L = caras propias). En este caso nos sale que necesitamos los 7 primeros Componentes Principales.

E_restriction <- list()
L <- numeric()
for (i in seq_along(eigCXs$values)){
  print(i)
  if (i==1){
    E_restriction[i] <- as.numeric(eigCXs$values[i]*100/sum(eigCXs$values))    
  }
  else {
    E_restriction[i] <- as.numeric(E_restriction[i-1]) + as.numeric(eigCXs$values[i]*100/sum(eigCXs$values))
    if (E_restriction[i] > 60) {
      print(paste("L =", i))
      L <- i
      break
    }
  }
  print(E_restriction)
}


# 6-------------------------------------------------------------------------------------------------
# 6.1 Calcular error de reconstrucción para cada persona X_err = Xs-Xs_rec. Un vez encontrado, buscar
# el coeficiente R2 que determina la calidad de la reconstrucción.

# Aquí cogemos la L que nos ha salido en el apartado anterior y seleccionamos los vectores propios
# indicados por ese valor (los 7 primeros). Recordemos que los eigenvectores provienen de la matriz de
# covarianzas, y que la matriz eigen funciona como aplicación lineal o matriz de transformación P.
# Seguidamente, calculamos la matriz reducida T_reduc.
# P_reduc <- eigCXs$vectors[,1:2000]
P_reduc <- eigCXs$vectors[,1:L]
T_reduc <- X_vector%*%P_reduc

# Al haber reducido la dimensionalidad, la matriz P_reduc ya no es invertible. Es decir, los datos 
# originales contenidos en X no se pueden recuperar completamente mediante la matriz T_reduc, y si
# aún así realizamos la inversión, como es el caso en este ejericio, debemos saber que tendremos una 
# pérdida de información. Esta pérdida de información se llama error residual.

# Reconstrucción de los datos (Xs_rec) y estudio del error residual cometido para el valor
Xs_rec <- T_reduc %*% t(P_reduc)

# Como yo estoy utilizando X_vector, no voy a poder aplicar esta fórmula tal cual, ya que mi T está
# calculada sobre X_vector y no sobre Cx (que también sería posible porque la matriz de covarianzas 
# es una base de X). No obstante mantengo el nombre de Xs_rec, aunque no sea accurate.
# X_err = Xs-Xs_rec
# X_err <- list()
# for (i in 1:40){
# X_err = X_vector-Xs_rec[i,]
# }

# Cálculo del error de reconstrucción
X_err = X_vector-Xs_rec

# Atención, los datos del formulario Moodle con corresponden con los calculados aquí.--------------
# Aquí se encuentran los datos actualizados.-------------------------------------------------------

# Coeficiente R2 que determina la calidad de la reconstrucción
R2 = 1 - apply(X_err, 1, var) / apply(X_vector, 1, var)

# 6.2 y 6.3 Encontrar qué personas obtienen un R2 mayor y menor. Identificar cada persona con el 
# número de cara entre [1, 40] correspondiente.  Visualizar y adjuntar la cara de las personas 
# identificadas en el punto anterior. Discutir si las personas con mayor error tienen algún rasgo 
# facial concreto que pueda explicar por qué se obtiene un error mayor.

# Mejor reconstrucción
mejor_reconstruccion = round(max(R2),2)
which(R2==max(R2))
# plt_img(X_matrix[10,,])

# Visualización de la mejor reconstrucción
for (i in 1:40){
  if (i == 10) {
    plt_img(matrix(as.numeric(Xs_rec[i,]),nrow=56,byrow=F))   
  }
}

# Peor reconstrucción
peor_reconstruccion = round(min(R2),2)
which(R2==min(R2))
plt_img(X_matrix[33,,])

# Visualización de la peor reconstrucción
for (i in 1:40){
  if (i == 33) {
    plt_img(matrix(as.numeric(Xs_rec[i,]),nrow=56,byrow=F))    
  }
}

# Mirando las reconstrucciones, creo que L=7 se queda corto para reconstruir las caras originales.

# Caras más nítidas
# X_orig_rec_10 = Xs_rec[10,]*X_std + X_mean
# plt_img(X_orig_rec_10)

X_orig_rec_10 = X_vector[10,]*X_std + X_mean
plt_img(X_orig_rec_10)

# X_orig_rec_33 = Xs_rec[33,]*X_std + X_mean
# plt_img(X_orig_rec_33)

X_orig_rec_33 = X_vector[33,]*X_std + X_mean
plt_img(X_orig_rec_33)


# ---------------------------------------------------------------------------------------------------

# Discusión sobre los resultados: ordenando los valores de R2 de menor a mayor e inspeccionando las 
# imágenes, tengo la sensación de que las imágenes que tienen menos contraste (imágenes más homogéneas,
# píxeles de tonos más parecidos, menos contraste) se reconstruyen peor que aquellas otras imágenes que
# tienen mayor contraste, más diferencia entre píxeles claros y oscuros. También creo que influye la 
# presencia del fondo y su color, cuanto más se vea el fondo y más distinto sea este fondo del color 
# de pelo y de la piel, peor reconstrucción.









