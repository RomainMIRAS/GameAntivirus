with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with ada.calendar; use ada.calendar;
with p_vue_graph; use p_vue_graph;
with p_virus ; use p_virus ;
with sequential_io;
use p_virus.p_coul_io;
use p_virus.p_piece_io;
use p_virus.p_dir_io;
with p_esiut; use p_esiut;
use p_vue_graph.p_classement_io;
with text_io; use text_io;

procedure av_graph is

  -- Declaration pour le jeu

  Classement : p_vue_graph.p_classement_io.file_type;

  Grille : TV_Grille;

  Pieces : TV_Pieces;

  Piece : T_coulP := rouge; -- Valeur de Défault de la piéce sélectionner Rouge

  Defi : p_virus.p_piece_io.file_type;

  NumDefi : integer range 1..20;

  HeureDeb,HeureFin : Time;

  TempsPris : TR_Temps; -- Temps Chrono

  TouteCouleur : T_CoulGraph := (FL_RED,FL_DARKCYAN,FL_DARKORANGE,FL_DEEPPINK,FL_DARKTOMATO,FL_BLUE,FL_DARKVIOLET,FL_GREEN,FL_YELLOW,FL_WHITE,FL_COL1);

  -- Declaration pour le jeu graphique

  Accueil, Regles, Fin, Jeu : TR_Fenetre;
  Bouton : string(1..3);
  Quitter, Option, PAccueil, PFin, PRegles, PJeu: boolean := false;
  SizeX : natural := 650;
  SizeY : natural := 650;

  NbDep, NbErr : natural := 0;
  BoolDep : boolean := false;

  Pseudo : string(1..20) := (others => ' ');

  TxtClassement : text_io.file_type;

begin
  -------------------------------------------------------------------
  -- Initialisation du programme



  InitialiserFenetres;
  open(Defi, in_file,"Defis.bin");
  open(Classement,append_file, "Classement.bin");
  create(TxtClassement,out_file, "Classement.txt");

  InitPartie(Grille,Pieces);
-------------------------------------------------------------------
-- Debut déclaration fenêtre accueil
  Accueil := DebutFenetre("Accueil",SizeX,SizeY);

  AjouterTexte(Accueil,"Titre","Bienvenue dans Anti Virus ",(SizeX/2)-150,100,300,40);
  ChangerAlignementTexte(Accueil,"Titre",FL_ALIGN_CENTER);
  ChangerStyleTexte(Accueil,"Titre",FL_BOLDITALIC_STYLE);
  ChangerTailleTexte(Fin,"Titre",FL_large_Size);


  AjouterBouton(Accueil,"B01","Quitter",SizeX-100,0,100,50);
  ChangerCouleurFond(Accueil,"B01",FL_RED);


  AjouterBouton(Accueil,"B02","Les Regles",0,SizeY-50,100,50); -- Bouton Regles
  ChangerCouleurFond(Accueil,"B02",FL_CYAN);


  AjouterBouton(Accueil,"B03","Start",SizeX-100,SizeY-50,100,50); -- Bouton Start
  ChangerCouleurFond(Accueil,"B03",FL_CHARTREUSE);

  AjouterChamp(Accueil,"C01","","Joueur 1",(SizeX/2)-75,250,150,40); -- Champ Pseudo

  AjouterTexte(Accueil,"Pseudo","Veillez entrer votre pseudo",(SizeX/2)-150,210,300,40);-- Texte pour Champ Pseudo
  ChangerAlignementTexte(Accueil,"Pseudo",FL_ALIGN_CENTER);
  ChangerTailleTexte(Fin,"Pseudo",FL_medium_Size);


  AjouterChamp(Accueil,"C02","","1",(SizeX/2)-75,350,150,40); -- Champ Défi

  AjouterTexte(Accueil,"Défi","Veillez un numero de defi (1-20) :",(SizeX/2)-150,310,300,40);-- Texte pour Champ Pseudo
  ChangerAlignementTexte(Accueil,"Défi",FL_ALIGN_CENTER);
  ChangerTailleTexte(Fin,"Défi",FL_medium_Size);



  AjouterTexte(Accueil,"Erreur Défi","Veillez mettre un defi entre 1 et 20 !",(SizeX/2)-150,450,300,20); -- Gestion Erreur Defi
  ChangerCouleurTexte(Accueil,"Erreur Défi",FL_RED);
  ChangerStyleTexte(Accueil,"Erreur Défi",FL_Bold_Style);
  ChangerTailleTexte(Fin,"MessVictoire",FL_medium_Size);
  ChangerAlignementTexte(Accueil,"Erreur Défi",FL_ALIGN_CENTER);
  CacherElem(Accueil,"Erreur Défi");

  AjouterTexte(Accueil,"ErreurNom","Veillez mettre un nom moins de 20 characteres!",(SizeX/2)-200,470,400,20); -- Gestion Erreur nom

  ChangerCouleurTexte(Accueil,"ErreurNom",FL_RED);
  ChangerStyleTexte(Accueil,"ErreurNom",FL_Bold_Style);
  ChangerAlignementTexte(Accueil,"ErreurNom",FL_ALIGN_CENTER);
  CacherElem(Accueil,"ErreurNom");

  FinFenetre(Accueil);
  -- Fin déclaration fenêtre accueil

--------------------------------------------------------------------

-- Debut déclaration fenêtre des régles

Regles:=DebutFenetre("Regles",SizeX,SizeY);

AjouterBouton(Regles,"B01","Accueil",SizeX-100,SizeY-50,100,50); -- Pour le retour à la page accueil
ChangerCouleurFond(Regles,"B01",FL_CYAN);
CacherElem(Regles,"B01");-- Defaut pas visible


AjouterBouton(Regles,"B02","Jeu",SizeX-100,SizeY-50,100,50); -- Pour le retour à la page jeu
ChangerCouleurFond(Regles,"B02",FL_CHARTREUSE);
CacherElem(Regles,"B02");-- Defaut pas visible


AjouterTexte(Regles,"Titre","Les Regles du Jeu",SizeX/2-(235/2),1,235,50);
AjouterTexte(Regles,"Regles","Au debut de chaque partie, vous devez choisir un defi de 1 a 20",40,90,550,20);
AjouterTexte(Regles,"niveau1","- niveau Starter (defis 1 a 5)",50,90+20,550,20);
AjouterTexte(Regles,"niveau2","- niveau Junior (defis 6 a 10)",50,90+40,550,20);
AjouterTexte(Regles,"niveau3","- niveau Expert (defis 11 a 15)",50,90+60,550,20);
AjouterTexte(Regles,"niveau4","- niveau Wizard (defis 19 a 20)",50,90+80,550,20);
AjouterTexte(Regles,"jaune","Deplacements possibles pour la piece jaune :",285,90+180,310,20);

AjouterTexte(Regles,"Reglesjaune","Elle ne peut se deplacer que dans la",310,90+200,315,20);
AjouterTexte(Regles,"Reglesjanue2","direction : haut/gauche ou bas/gauche",310,90+220,310,20);

AjouterTexte(Regles,"rouge","Deplacements possibles pour la piece rouge :",285,90+250,315,20);
AjouterTexte(Regles,"Reglesrouge","Elle n'est pas deplacable car elle est bloquee ",310,90+270,310,20);
AjouterTexte(Regles,"Reglesrouge","Il vas falloir deplacer la piece jaune d'abord",310,90+290,310,20);

AjouterTexte(Regles,"blanche","Les pieces de couleur Blanche sont Fixe",285,90+320,310,20);

AjouterTexte(regles,"regles2","Une partie est gagnee quand le virus (piece rouge) est positionne en haut a gauche du plateau.",20,90+440,585,40);

AjouterImage(Regles,"TEST","pogchamp.xpm","Example : Defi 2",40,90+140,240,241);

ChangerStyleTexte(Regles,"Titre",FL_Bold_Style);
ChangerStyleTexte(Regles,"Regles",FL_Bold_Style);
ChangerStyleTexte(Regles,"jaune",FL_Bold_Style);
ChangerStyleTexte(Regles,"rouge",FL_Bold_Style);
ChangerStyleTexte(Regles,"blanche",FL_Bold_Style);
ChangerStyleTexte(Regles,"Regles2",FL_Bold_Style);


ChangerTailleTexte(Regles,"Titre",FL_LARGE_SIZE);
FinFenetre(Regles);

-- Fin déclaration fenêtre accueil

--------------------------------------------------------------------

-- Début déclaration fenêtre Page de Fin

    Fin := DebutFenetre("Fin", SizeX, SizeY);

    AjouterBouton(Fin, "B01", "Retour acceuil", 1, SizeY-51, 125, 50);
    AjouterBouton(Fin, "B02", "Quitter", SizeX-125, 0, 125, 50);
    AjouterBouton(Fin, "B03", "Niveau suivant", SizeX-126, SizeY-51, 125, 50);

    AjouterTexte(Fin,"MessVictoire", "", (SizeX/2)-200, 50, 400, 50);
    ChangerAlignementTexte(Fin,"MessVictoire",FL_ALIGN_CENTER);

    AjouterTexte(Fin, "Credit1", "Ce jeu a ete cree par :", SizeX/2-80, 400, 200, 50);
    AjouterTexte(Fin, "Credit2", "RRAHMANI Altin, ARLE Alexandre", SizeX/2-118, 435, 236, 50);
    AjouterTexte(Fin, "Credit3", "&", SizeX/2-10, 470, 200, 50);
    AjouterTexte(Fin, "Credit4", "MIRAS Romain, DEL MEDICO Remi", SizeX/2-118, 505, 236, 50);

    ChangerTailleTexte(Fin,"MessVictoire",FL_medium_Size);
    changerCouleurFond(fin,"B03", FL_GREEN);
    changerCouleurFond(fin,"B02", FL_RED);
    changerCouleurFond(fin,"B01", FL_CYAN);

    AjouterImage(Fin,"Win","win.xpm","",SizeX/2-120,120,240,250);

    AjouterTexte(Fin,"leTemps", "", (SizeX/2)-200, 373, 400, 30);
    ChangerAlignementTexte(Fin,"leTemps",FL_ALIGN_CENTER);

    AjouterTexte(Fin,"TClassement", "Votre resultat a ete envoye au fichier : Classement.txt", (SizeX/2)-200, 573, 400, 30);
    ChangerAlignementTexte(Fin,"TClassement",FL_ALIGN_CENTER);



    FinFenetre(Fin);

-- Fin déclaration fenêtre Page de Fin

-------------------------------------------------------------------
-- Début déclaration fenêtre Page de Jeu

Jeu := DebutFenetre("ANTI-VIRUS",650,650);

  -- 3 boutons

  AjouterBouton(Jeu,"B01","Options",550,0,100,50);
  ChangerCouleurFond(Jeu,"B01",FL_INACTIVE);

  AjouterBouton(Jeu,"B02","Les Regles",0,600,100,50);
  ChangerCouleurFond(Jeu,"B02",FL_CYAN);

  -- AjouterBouton(Jeu,"B03","Deplacer",550,600,100,50);
  --   ChangerCouleurFond(Jeu,"B03",FL_CHARTREUSE);

  -- 3 boutons (options)

  AjouterBouton(Jeu,"B08","Changer defi",550,50,100,50);
  ChangerCouleurFond(Jeu,"B08",FL_COL1);
  CacherElem(Jeu,"B08");

  AjouterBouton(Jeu,"B09","Recommencer",550,100,100,50);
  ChangerCouleurFond(Jeu,"B09",FL_COL1);
  CacherElem(Jeu,"B09");


  AjouterBouton(Jeu,"B10","Quitter",550,150,100,50);
  ChangerCouleurFond(Jeu,"B10",FL_RED);
  CacherElem(Jeu,"B10");

-- 4 boutons de directions

AjouterBoutonRond(Jeu,"B04","HG",380,300,50);
ChangerCouleurFond(Jeu,"B04",FL_WHITE);
AjouterImage(Jeu,"hg","hg.xpm","",392,310,30,30);

AjouterBoutonRond(Jeu,"B05","HD",480,300,50);
ChangerCouleurFond(Jeu,"B05",FL_WHITE);
AjouterImage(Jeu,"hd","hd.xpm","",492,310,30,30);

AjouterBoutonRond(Jeu,"B06","BD",480,400,50);
ChangerCouleurFond(Jeu,"B06",FL_WHITE);
AjouterImage(Jeu,"bd","bd.xpm","",492,410,30,30);

AjouterBoutonRond(Jeu,"B07","BG",380,400,50);
ChangerCouleurFond(Jeu,"B07",FL_WHITE);
AjouterImage(Jeu,"bg","bg.xpm","",392,410,30,30);

  -- piece selectionnee

  AjouterTexte(Jeu,"T01","Piece selectionnee : ",370,220,200,40);
  AjouterBouton(Jeu,"B11","",510,220,40,40);
  ChangerCouleurFond(Jeu,"B11",FL_COL1);
  ChangerEtatBouton(Jeu, "B11", arret);

 --- Texte D'Erreur

 AjouterTexte(Jeu,"ErreurDep","Deplacement de la piece Impossible",320,520,300,40);
 ChangerCouleurTexte(Jeu,"ErreurDep",FL_RED);
 ChangerStyleTexte(Jeu,"ErreurDep",FL_Bold_Style);
 ChangerTailleTexte(Jeu,"ErreurDep",FL_medium_Size);
 CacherElem(Jeu,"ErreurDep");-- Cacher par défaut

 -- Horloge

AjouterHorlogeDigi(Jeu,"Clock","",550,600,100,50);
ChangerCouleurFond(Jeu,"Clock",FL_DODGERBLUE);

-- grille

AfficheGrille(Jeu, Grille, 0, 0, true);

  -- deplacement
  AjouterTexte(Jeu,"NbDep","Nombre de deplacements :" & natural'image(NbDep),1,280,300,40);
  AjouterTexte(Jeu,"NbErr","Nombre d'erreurs :" & natural'image(NbErr),1,310,300,40);
  AjouterTexte(Jeu,"AvErr","Preter attention a votre compteur d'erreurs.",1,340,300,40);

  FinFenetre(Jeu);


-- Fin déclaration fenêtre Page de Jeu

--------------------------------------------------------------------


  MontrerFenetre(Accueil);

PAccueil := true;

loop
  --------------------- Accueil --------------------

  if PAccueil then
    Bouton := AttendreBouton(Accueil);
    if Bouton = "B01" then -- Si Bouton Quitter
      Quitter := true;
      PAccueil := false; -- Sortie boucle accueil
    elsif Bouton = "B02" then -- Si Bouton Regles
      MontrerElem(Regles,"B01");-- Bouton Retour Accueil
      SwapPage(Accueil,Regles,PAccueil,PRegles); -- Go to Page Regles
    elsif Bouton = "B03" then -- Si Bouton Start
      if integer'value(ConsulterContenu(Accueil,"C02")) >= 1 and integer'value(ConsulterContenu(Accueil,"C02")) <=20 and (ConsulterContenu(Accueil,"C01")'length) <= 20 then
	CacherElem(Accueil,"ErreurNom");
        NumDefi := integer'value(ConsulterContenu(Accueil,"C02"));
	InitPartie(Grille,Pieces);
        Configurer(Defi,NumDefi,Grille,Pieces);
        CacherElem(Accueil,"Erreur Défi");
	Pseudo(1..ConsulterContenu(Accueil,"C01")'length) := ConsulterContenu(Accueil,"C01");
        SwapPage(Accueil,Jeu,PAccueil,PJeu);
        AfficheGrille(Jeu, Grille, 0, 0, true);
        HeureDeb := clock;
	NbDep := 0;
        NbErr := 0;
	ChangerTexte(Jeu,"NbDep","Nombre de deplacements :" & natural'image(NbDep));
        ChangerTexte(Jeu,"NbErr","Nombre d'erreurs :" & natural'image(NbErr));
      elsif (ConsulterContenu(Accueil,"C01")'length) > 20 then
        MontrerElem(Accueil,"ErreurNom"); -- Montrer Erreur
      else
        MontrerElem(Accueil,"Erreur Défi"); -- Montrer Erreur
      end if;
    end if;
  end if;

--------------------- REGLE --------------------
  if PRegles then
    Bouton := AttendreBouton(Regles);
    if Bouton = "B01" then -- Si Bouton Accueil
      CacherElem(Regles,"B01");
      SwapPage(Regles,Accueil,PRegles,PAccueil);
    elsif Bouton = "B02" then -- Si Bouton Jeu
      CacherElem(Regles,"B02");
      SwapPage(Regles,Jeu,PRegles,PJeu);
    end if;
  end if;

  --------------------- Jeu --------------------

  if PJeu then
    Bouton := AttendreBouton(Jeu);

    TestOption(Jeu,Bouton,Option);

    DeplacementPiece(Jeu,Pieces,Grille,Piece,Bouton,NbDep,NbErr);
    ChangerTexte(Jeu,"NbDep","Nombre de deplacements :" & natural'image(NbDep));
    ChangerTexte(Jeu,"NbErr","Nombre d'erreurs :" & natural'image(NbErr));

    If Bouton(Bouton'First) = 'G' then -- Si il appartient au bouton de la grille
      ChoixCouleurDep(Grille,Piece,Bouton);
      ChangerCouleurFond(Jeu,"B11",TouteCouleur(T_coul'pos(piece)));
    end if;

    -- Gestion des Options
    if bouton = "B08" then -- changer défi
      NbDep := 0;
      NbErr := 0;
      ChangerTexte(Jeu,"NbDep","Nombre de deplacements :" & natural'image(NbDep));
      ChangerTexte(Jeu,"NbErr","Nombre d'erreurs :" & natural'image(NbErr));
      InitPartie(Grille,Pieces);
      SwapPage(Jeu,Accueil,PJeu,PAccueil);
    elsif bouton = "B09" then -- Recommencer
      NbDep := 0;
      NbErr := 0;
      ChangerTexte(Jeu,"NbDep","Nombre de deplacements :" & natural'image(NbDep));
      ChangerTexte(Jeu,"NbErr","Nombre d'erreurs :" & natural'image(NbErr));
      InitPartie(Grille,Pieces);
      Configurer(Defi,NumDefi,Grille,Pieces);
      AfficheGrille(Jeu, Grille, 0, 0, true);
    elsif bouton = "B10" then -- Si quitter
      Quitter := true;
      PJeu := false; -- Sortie boucle Jeu
    end if;

--- Gestion bouton régles
    if bouton = "B02" then
      MontrerElem(Regles,"B02");-- Bouton Retour Jeu
      SwapPage(Jeu,Regles,PJeu,PRegles); -- Go to Page Regles
    end if;

    if Guerison(Grille) then -- Teste de Fin
      ChangerTexte(Fin,"MessVictoire","Bien joue a " & ConsulterContenu(Accueil,"C01") & "! Tu as gagne !"); -- texte selon pseudo
      SwapPage(Jeu,Fin,PJeu,PFin);
      HeureFin := clock;
      temps(Fin,"leTemps",heuredeb,heurefin,TempsPris);
      NbDep := 0;
      NbErr := 0;
      ChangerTexte(Jeu,"NbDep","Nombre de deplacements :" & natural'image(NbDep));
      ChangerTexte(Jeu,"NbErr","Nombre d'erreurs :" & natural'image(NbErr));
      GestionClassement(Classement,TxtClassement,(Pseudo,NumDefi,TempsPris));
    end if;

   if NbErr = 25 then
	ChangerCouleurTexte(Jeu,"AvErr",FL_RED);
	ChangerTexte(Jeu,"AvErr","Attention, vous avez depasser 25 erreurs !!");
   end if;

   if NbErr = 40 then
	ChangerCouleurTexte(Jeu,"AvErr",FL_RED);
	ChangerTexte(Jeu,"AvErr","Aie, aie, aie !!");
   end if;

   if NbErr = 50 then
	ChangerCouleurTexte(Jeu,"AvErr",FL_RED);
	SwapPage(Jeu,Accueil,PJeu,PAccueil);
   end if;

  end if;

  --------------------- Fin --------------------
    if PFin then
      if NumDefi = 20 then -- Si Niveau 20 atteints => Pas de bouton "Niveau Suivant"
        CacherElem(Fin,"B03");
      end if;

      Bouton := AttendreBouton(Fin);
      if Bouton = "B01" then -- Si Bouton Accueil
        InitPartie(Grille,Pieces);
        SwapPage(Fin,Accueil,PFin,PAccueil);
      elsif Bouton = "B02" then -- Si Quitter
        Quitter := true;
        PFin := false; -- Sortie boucle Jeu
      elsif Bouton = "B03" then -- Si Bouton Niveau suivant
        NumDefi := NumDefi + 1;
        InitPartie(Grille,Pieces);
        Configurer(Defi,NumDefi,Grille,Pieces);
        SwapPage(Fin,Jeu,PFin,PJeu);
        AfficheGrille(Jeu, Grille, 0, 0, true);
        HeureDeb := clock;
      end if;
    end if;

  exit when Quitter;
end loop;


end av_graph;
