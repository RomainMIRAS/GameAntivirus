with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with ada.calendar; use ada.calendar;
with p_virus ; use p_virus;
with p_esiut;use p_esiut;
with sequential_io;
with text_io; use text_io;

package p_vue_graph is

type TR_Temps is record
    min : natural range 0..60;
    sec : natural range 0..60;
end record;

type T_CoulGraph is array(0..10) of FL_COLOR;

type TR_Classement is record -- AjouterBin
  Pseudo : string(1..20);
  Niveau : integer range 1..20;
  Temps  : TR_Temps;
end record;

type TV_Classement is array(positive range <>) of TR_Classement;

package p_classement_io is new sequential_io (TR_Classement); use p_classement_io;

procedure SwapPage(Page1,Page2 : in out TR_Fenetre; Affiche1,Affiche2 : out boolean);
-- Permet de changer la page afficher de la page 1 à la page 2

procedure DeplacementPiece(Page : in out TR_Fenetre; Pieces : in out TV_Pieces; Grille : in out TV_Grille; Piece : in T_CoulP; Dep : in String; nbdep,nberr : in out natural);
  -- Deplace la piéce sélectionner par l'utilisateur
  -- Si Dep impossible. Affiche une Erreur à l'utilisateur


procedure AfficheGrille (Fen : in out TR_Fenetre; G : in out TV_Grille; posX, posY : natural; Clickable : boolean);
-- Affiche la grille cliquable pour l'utilisateur

procedure TestOption(Page : in out TR_Fenetre;Bouton : in String;Option : in out boolean);
-- Gestion des boutons options.

procedure ChoixCouleurDep(Grille : in out TV_Grille; Piece : out T_CoulP; Bouton : in string);

procedure Temps (Fen : in out TR_Fenetre; nom : in string; hdep, hfin : in Time;hf:in out TR_temps);
-- Donne le temps en min sec

Function AfficheTemps(Temps : in TR_Temps) return string;
-- Retourne une chaine de caractères de temps (ex : "15min25")

procedure AjouterClassement(f : in out p_classement_io.file_type; Classement : in TR_Classement);
  --{f ouvert} => {F sera ajouter à la fin de son fichier de Classement}

function InfStrictTemps(s1, s2 : in TR_Temps) return boolean;
--{} => {résultat = vrai si s1 est strictement inférieur à s2 selon l'ordre (min, sec)}

function InfStrict(s1, s2 : in TR_Classement) return boolean;
--{} => {résultat = vrai si s1 est strictement inférieur à s2 selon l'ordre (Niveau, Temps)}

procedure FClassementT0VClassement(f : in out p_classement_io.file_type; V : in out TV_Classement);
--{f ouvert non vide, V'length = card(f)} => {V contient les éléments de f (dans le même ordre)}


procedure VClassementT0FClassement(V : in TV_Classement; f : in out p_classement_io.file_type);
--{f ouvert} => {f contient les éléments de V (dans le même ordre)}


function nbelem(f : in p_classement_io.file_type) return natural;
--{f ouvert en lecture} => {résultat = nombre d'éléments de f}


procedure TriFicClassement(f : in out p_classement_io.file_type);
-- Trie le fichier binaire Classement à l'aide d'un tri a bulle optimisé
-- Dans l'ordre (Niveau,Temps)

procedure CreationTXT(f : in out p_classement_io.file_type; g : in out text_io.file_type);
  --{f trié dans l'ordre (Niveau, Temps), non vide et ouvert
  -- g ouvert
  --       => {g contient une page pour chaque niveau
  --                     dans chaque page, la liste des participants au niveau triée selon leurs classement (Niveau, temps)
  --                     La première ligne de chaque nous raménent au niveau qu'elles traitent


procedure GestionClassement(f : in out p_classement_io.file_type; g : in out text_io.file_type; Classement : in TR_Classement);
-- Fait tout


end p_vue_graph;
