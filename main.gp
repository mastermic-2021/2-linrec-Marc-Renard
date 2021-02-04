u27 = ffgen(('x^3-'x+1)*Mod(1,3),'u);
codf27(s) = [if(x==32,0,u27^(x-97))|x<-Vec(Vecsmall(s)),x==32||x>=97&&x<=122];

ascii2str(v)=Strchr(v);

table=[0..26];
for(i=1,26,table[i]=(u27)^(table[i]));  \\permettra de faire le codage et décodage
table[27]=0;

decodf27(s) = {
	for(i=1,#s,j=1; while(j<=27,if(s[i]==table[j],s[i]=j%27; break);j++));
	for(i=1,#s,if(s[i]==0,s[i]=32,s[i]=s[i]+96));
	s=ascii2str(s);
}
\\LA fonction decodf27 va pour chaque élément de s chercher dans le tableau table à quel indice le caratère se trouve. Etant donné que les indices commencent à 1 et non à 0, j'ajoute seulement 96 pour repasser au code ASCII. 


expoRapideMat(Matrice,n) = {
	if(n==0,return (mathid(matsize(Matrice)[1])));
	if(n==1,return (Matrice));
	if(n%2==0,return (expoRapideMat(Matrice^2,n/2)),return(Matrice*expoRapideMat(Matrice^2,(n-1)/2)));	
}
\\ Exponentiation rapide appliquer aux matrice. Nous n'avons pas besoin de faire de modulo car les calculs se font dans F27.


text=readvec("input.txt")[1]; \\Récupération du fichier input
\\text[1] contient le mauvais chiffré, text[2] contient le bon chiffré et text[3] contient le nombre de répétitions

\\ Définition de la matrice de transition de la LSFR
M=matrix(40,40,i,j,if(j==i+1,1,0));
M[40,1]=-u27;
M[40,2]=-1;

\\ et inversion
M=M^(-1);

bonChiffre=text[2];

bonChiffreCode=(codf27(text[2])); \\codage du message chiffré
bonChiffreCode=bonChiffreCode~; \\ passage en vecteur colonne

\\exponentiation successives aux puissances: les diviseurs du nombre de répétitions
\\En plusieurs étapes pour éviter le stack overflow
M=expoRapideMat(M,32*7*47*71);
M=expoRapideMat(M,239);
M=expoRapideMat(M,5203391);

\\Application de la matrice inverse pour revenir au code du message original
messageCode=M*bonChiffreCode;
\\On remet le vecteur en horizontal
messageCode=messageCode~;
\\on décode le message
message=decodf27(messageCode);
\\on l'affiche
print(message);

