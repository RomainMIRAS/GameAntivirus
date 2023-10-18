package body p_vue_graph is

  procedure SwapPage(Page1,Page2 : in out TR_Fenetre; Affiche1,Affiche2 : out boolean) is
  -- Permet de changer la page afficher de la page 1 à la page 2
  begin
    Affiche1 := false;
    CacherFenetre(Page1);
    Affiche2 := true;
    MontrerFenetre(Page2);
  end SwapPage;

procedure DeplacementPiece(Page : in out TR_Fenetre; Pieces : in out TV_Pieces; Grille : in out TV_Grille; Piece : in T_CoulP; Dep : in String; nbdep, nberr : in out natural) is
  -- Deplace la piéce sélectionner par l'utilisateur
  -- Si Dep impossible. Affiche une Erreur à l'utilisateur;
begin
    if Dep = "B04" then
      if Possible(Grille,Piece,hg) then
        CacherElem(Page,"ErreurDep");
        MajGrille(Grille,Piece,hg);
        AfficheGrille(Page,Grille, 0, 0, true);
	nbdep := nbdep+1;
      else
        MontrerElem(Page,"ErreurDep");
	nberr := nberr+1;
        ChangerTexte(Page,"ErreurDep","Deplacement du " & T_Coul'Image(Piece) & " en Haut a Gauche" & " Impossible");
      end if;
    elsif Dep = "B05" then
      if Possible(Grille,Piece,hd) then
        CacherElem(Page,"ErreurDep");
        MajGrille(Grille,Piece,hd);
        AfficheGrille(Page,Grille, 0, 0, true);
	nbdep := nbdep+1;
      else
        MontrerElem(Page,"ErreurDep");
	nberr := nberr+1;
        ChangerTexte(Page,"ErreurDep","Deplacement du " & T_Coul'Image(Piece) & " en Haut a Droite" & " Impossible");
      end if;
    elsif Dep = "B06" then
      if Possible(Grille,Piece,bd) then
        CacherElem(Page,"ErreurDep");
        MajGrille(Grille,Piece,bd);
        AfficheGrille(Page,Grille, 0, 0, true);
	nbdep := nbdep+1;
      else
        MontrerElem(Page,"ErreurDep");
	nberr := nberr+1;
        ChangerTexte(Page,"ErreurDep","Deplacement du " & T_Coul'Image(Piece) & " en Bas a Droite" & " Impossible");
      end if;
    elsif Dep = "B07" then
      if Possible(Grille,Piece,bg) then
        CacherElem(Page,"ErreurDep");
        MajGrille(Grille,Piece,bg);
        AfficheGrille(Page,Grille, 0, 0, true);
	nbdep := nbdep+1;
      else
        MontrerElem(Page,"ErreurDep");
	nberr := nberr+1;
        ChangerTexte(Page,"ErreurDep","Deplacement du " & T_Coul'Image(Piece) & " en Bas a Gauche" & " Impossible");
      end if;
    end if;
end DeplacementPiece;

procedure AfficheGrille (Fen : in out TR_Fenetre; G : in out TV_Grille; posX, posY : natural; Clickable : boolean) is
  -- Affiche la grille cliquable pour l'utilisateur
  ch:string(1..3);
  ch2:string(1..2);
  Couleur : T_CoulGraph := (FL_RED,FL_DARKCYAN,FL_DARKORANGE,FL_DEEPPINK,FL_DARKTOMATO,FL_BLUE,FL_DARKVIOLET,FL_GREEN,FL_YELLOW,FL_WHITE,
  FL_COL1);
begin
  for i in G'Range(1) loop
    for j in G'Range(2) loop
      if (i mod 2 = 1 and T_Col'pos(j) mod 2 = 1) or (i mod 2 = 0 and T_Col'pos(j) mod 2 = 0) then
        if ((i-1)*7+(T_Col'pos(j)-65)) < 10 then
          ch2:=integer'image((i-1)*7+(T_Col'pos(j)-65));
          AjouterBouton(Fen,"G0" & ch2(ch2'last),"",(posX+(T_Col'pos(j)-65)*40),posY+((i-1)*40),40,40);
          ch := "G0" & ch2(ch2'last);
        else
          ch:=integer'image((i-1)*7+(T_Col'pos(j)-65));
          AjouterBouton(Fen,"G" & ch(2..ch'last),"",(posX+(T_Col'pos(j)-65)*40),posY+((i-1)*40),40,40);
          ch := "G" & ch(2..ch'last);
        end if;
        for k in 0..10 loop
          if G(i,j) = T_Coul'val(k) then
            ChangerCouleurFond(Fen,ch,Couleur(k));
            ChangerEtatBouton(Fen,ch, marche);
          end if;
        end loop;
        if G(i,j) = vide or G(i,j) = blanc or not Clickable then
          ChangerEtatBouton(Fen,ch, arret);
        end if;
      end if;
    end loop;
  end loop;
end AfficheGrille;

procedure TestOption(Page : in out TR_Fenetre;Bouton : in String; Option : in out boolean) is
-- Gestion des boutons options.
begin
  if Bouton = "B01" and not option then
    MontrerElem(Page, "B08");
    MontrerElem(Page, "B09");
    MontrerElem(Page, "B10");
    option := true;
  elsif bouton = "B01" and option then
    CacherElem(Page, "B08");
    CacherElem(Page, "B09");
    CacherElem(Page, "B10");
    option := false;
  end if;

end TestOption;

procedure ChoixCouleurDep(Grille : in out TV_Grille; Piece : out T_CoulP; Bouton : in string) is
  j,i : integer;
  NumBoutonClic : string := Bouton(Bouton'first+1..Bouton'last);
begin
if (((integer'value(NumBoutonClic) + 1)) mod 7) = 0 then
	j := 7;
else
    j := (((integer'value(NumBoutonClic) + 1)) mod 7);
    end if;
    i := (((integer'value(NumBoutonClic) - j )+1) / 7);
      for k in Grille'range(1) loop
        for l in Grille'range(2) loop
          if k = i+1 and l = T_col'val(j+64) then
              piece := grille(k, l);
          end if;
        end loop;
    end loop;

end ChoixCouleurDep;

procedure Temps (Fen : in out TR_Fenetre; nom : in string; hdep, hfin : in Time;hf:in out TR_temps) is
-- Donne le temps en min sec
    hfinal : natural;
begin
    hfinal := natural(hfin-hdep);

    if hfinal > 60 then
        hf.min := hfinal/60;
        hf.sec := (hfinal-((hfinal/60)*60));
        ChangerTexte(Fen,nom,"BRAVO !!! tu as gagne en" & natural'image(hf.min) & "min" & natural'image(hf.sec) & "sec");
    else
        hf.min := 0;
        hf.sec := hfinal;
        ChangerTexte(Fen,nom,"BRAVO !!! tu as gagne en" & natural'image(hf.sec) & "sec");
    end if;

end Temps;

Function AfficheTemps(Temps : in TR_Temps) return string is
  -- Retourne une chaine de caractères de temps (ex : "15min05")
  -- La chaine fera toujours 7 caractères (AVANTAGE POUR TRAITEMENT)

  min : string := (integer'image(Temps.min));
  sec : string := (integer'image(Temps.sec));

begin
  return (min & "min" & sec & "sec");
end AfficheTemps;

procedure AjouterClassement(f : in out p_classement_io.file_type; Classement : in TR_Classement) is
  --{f ouvert} => {F sera ajouter à la fin de son fichier de Classement}
begin
  reset(f,append_file);
  write(f,Classement);
end AjouterClassement;

function InfStrictTemps(s1, s2 : in TR_Temps) return boolean is -- AjouterBin
--{} => {résultat = vrai si s1 est strictement inférieur à s2 selon l'ordre (min, sec)}
begin
  return s1.min < s2.min or ( s1.min = s2.min and s1.sec < s2.sec);
end InfStrictTemps;

function InfStrict(s1, s2 : in TR_Classement) return boolean is -- AjouterBin
--{} => {résultat = vrai si s1 est strictement inférieur à s2 selon l'ordre (Niveau, Temps)}
begin
  return s1.niveau < s2.niveau or ( s1.niveau = s2.niveau and InfStrictTemps(s1.temps,s2.temps));
end InfStrict;

procedure FClassementT0VClassement(f : in out p_classement_io.file_type; V : in out TV_Classement) is
    --{f ouvert non vide, V'length = card(f)} => {V contient les éléments de f (dans le même ordre)}
    mot : TR_Classement;
    begin
        reset(f,in_file);
        for i in V'Range loop
            read(f,mot);
            V(i) := mot;
        end loop;
    end FClassementT0VClassement;

    procedure VClassementT0FClassement(V : in TV_Classement; f : in out p_classement_io.file_type) is
    --{f ouvert} => {f contient les éléments de V (dans le même ordre)}
       Classement : TR_Classement;
    begin
        reset(f,out_file);
        for i in V'Range loop
            Classement := V(i);
            write(f,Classement);
        end loop;
    end VClassementT0FClassement;

  function nbelem(f : in p_classement_io.file_type) return natural is
    --{f ouvert en lecture et possioner au début} => {résultat = nombre d'éléments de f}

    nbmot : integer := 0;
    Classement : TR_Classement;
  begin
    while not end_of_file(f) loop
      read(f,Classement);
      nbmot := nbmot + 1;
    end loop;
      return nbmot;
    end nbelem;

    procedure TriFicClassement(f : in out p_classement_io.file_type) is
    -- Trie le fichier binaire Classement à l'aide d'un tri a bulle optimisé
    -- Dans l'ordre (Niveau,Temps)
       V : TV_Classement(1..nbelem(f));
       motpermut : TR_Classement;
    begin

        FClassementT0VClassement(f,V);

        for i in V'first..V'last-1 loop
            for j in reverse i+1..V'last loop
                if InfStrict(V(j),V(j-1)) then
                    motpermut := V(j);
                    V(j) := V(j-1);
                    V(j-1) := motpermut;
                end if;
            end loop;
        end loop;
        VClassementT0FClassement(V,f);
    end TriFicClassement;

  procedure CreationTXT(f : in out p_classement_io.file_type; g : in out text_io.file_type) is
    --{f trié dans l'ordre (Niveau, Temps), non vide et ouvert
    -- g ouvert
    --       => {g contient une page pour chaque niveau
    --                     dans chaque page, la liste des participants au niveau triée selon leurs classement (Niveau, temps)
    --                     La première ligne de chaque nous raménent au niveau qu'elles traitent

    succ, pred : TR_Classement;
  begin

    reset(f,in_file);
    read(f,succ);


    while not end_of_file(f) loop
      put_line(g,"Classement du niveau " & integer'image(succ.niveau));
      loop
        new_line(g);
        put_line(g,succ.pseudo & "en : " & AfficheTemps(succ.Temps));
        pred := succ;
        read(f,succ);
      exit when end_of_file(f) or else succ.niveau > pred.niveau;
    end loop;

    if succ.niveau > pred.niveau then
      new_page(g);
    end if;
  end loop;

  -- Traitement du dernier mot
  if succ.niveau > pred.niveau then
    put_line(g,"Classement du niveau " & integer'image(succ.niveau));
    new_line(g);
    put_line(g,succ.pseudo & "en : " & AfficheTemps(succ.Temps));
  end if;

  -- Q10 := false;

  -- NE PAS MODIFIER --
  -- traitements protection des données
  exception
    when others => raise;
  end CreationTXT;

  procedure GestionClassement(f : in out p_classement_io.file_type; g : in out text_io.file_type; Classement : in TR_Classement) is
  -- Fait tout
  begin
    AjouterClassement(f,Classement);
    reset(f,in_file);
    TriFicClassement(f);
    close(g);
    create(g,out_file, "Classement.txt");
    CreationTXT(f,g);
  end GestionClassement;

end p_vue_graph;
