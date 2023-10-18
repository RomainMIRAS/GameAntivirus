package body p_virus is


  procedure InitPartie(Grille : in out TV_Grille; Pieces : in out TV_Pieces) is
    -- {} => {Tous les éléments de Grille ont été initialisés avec la couleur VIDE, y compris les cases inutilisables
    --    	Tous les élements de Pieces ont été initialisés à false}
  begin
    for i in Grille'range(1)  loop
      for j in Grille'range(2) loop
        Grille(i,j) := VIDE;
      end loop;
    end loop;

    for k in Pieces'range loop
      Pieces(k) := false;
    end loop;

  end InitPartie;

  procedure Configurer (f : in out p_piece_io.file_type; num : in integer; Grille : in out TV_Grille; pieces : in out TV_Pieces) is
    -- {f ouvert, non vide, num est un numéro de défi
    --	dans f, un défi est représenté par une suite d'éléments :
    --	* les éléments d'une même pièce (même couleur) sont stockés consécutivement
    --	* les deux éléments constituant le virus (couleur rouge) terminent le défi}
    -- 			=> {Grille a été mis à jour par lecture dans f de la configuration de numéro num
    --					Pieces a été mis à jour en fonction des pièces de cette configuration}

    i : integer := 1;
    elem : TR_ElemP;

  begin
    reset(f, in_file);


    while not end_of_file(f) and i < num loop
      read(f, elem);
      if elem.couleur = rouge then
        read(f, elem);
        i := i + 1;
      end if;
    end loop;

    while not end_of_file(f) and i = num loop
      read(f, elem);
      Grille(elem.ligne, elem.colonne) := elem.couleur;
      if pieces(elem.couleur) = false then
        pieces(elem.couleur) := true;
      end if;
      if elem.couleur = rouge then
        read(f, elem);
        i := i + 1;
        Grille(elem.ligne, elem.colonne) := elem.couleur;
      end if;
    end loop;

  end configurer;


  procedure PosPiece(Grille : in TV_Grille; coul : in T_coulP) is
    -- {} => {la position de la pièce de couleur coul a été affichée, si coul appartient à Grille:
    --				exemple : ROUGE : F4 - G5}

  begin

    ecrire(coul'image);

    for i in Grille'Range(1) loop
      for j in Grille'Range(2) loop

        if Grille(i,j) = coul then
          ecrire(" - " & i'image & j'image);
        end if;
      end loop;
    end loop;

    a_la_ligne;
  end PosPiece;

  function Possible(Grille : in TV_Grille; coul : in T_CoulP; Dir : in T_Direction) return boolean is
    -- {coul /= blanc}
    --	=> {resultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}

    possible : boolean := true;
  begin

  if coul = blanc then
    return false;
  else
    for i in Grille'Range(1) loop
      for j in Grille'Range(2) loop

        if Grille(i,j) = coul then

          if Dir = hg then
            if not (Grille(i-1,T_col'pred(j)) = VIDE)  and (Grille(i-1,T_col'pred(j)) /= coul) then
              possible := false;
            end if;
          elsif Dir = bg then
            if not (Grille(i+1,T_col'pred(j)) = VIDE) and (Grille(i+1,T_col'pred(j)) /= coul) then
              possible := false;
            end if;
          elsif Dir = hd then
            if not (Grille(i-1,T_col'succ(j)) = VIDE) and (Grille(i-1,T_col'succ(j)) /= coul)  then
              possible := false;
            end if;
          elsif Dir = bd then
            if (not (Grille(i+1,T_col'succ(j)) = VIDE) and (Grille(i+1,T_col'succ(j)) /= coul)) then
              possible := false;
          	end if;
          else
            possible := false;
          end if;
        end if;
      end loop;
    end loop;
    return possible;
  end if;
  exception when CONSTRAINT_ERROR => return false;
  end Possible;


  procedure MajGrille(Grille : in out TV_Grille; coul : in T_CoulP; Dir : in T_Direction) is
    -- {la pièce de couleur coul peut être déplacée dans la direction Dir}
    --	=> {Grille a été mis à jour suite au deplacement}
    y : integer;
    x : integer;
    type TR_case is record
      caseX : T_lig;
      caseY : T_col;
      Achanger : boolean := false;
    end record;

    type TV_tableau is array (natural range 0..T_lig'last*((T_col'pos(T_col'last)))) of TR_case;
    tableau : TV_tableau;


  begin
    for i in Grille'range(1) loop
      for j in Grille'range(2) loop
        if Grille(i, j) = coul then
          tableau(((i-1)*(T_col'pos(T_col'last))+T_Col'pos(j))).Achanger := true;
        end if;
      end loop;
    end loop;
    if Dir = hg or Dir = hd then
      x := -1;
    else
      x := 1;
    end if;

    if Dir = bd or Dir = hd then
      y := 1;
    else
      y := -1;
    end if;

    if Dir = bd or Dir = bg then
      for i in reverse Grille'range(1) loop
        for j in reverse Grille'range(2) loop
          if tableau((i-1)*T_col'pos(T_col'last)+T_Col'pos(j)).Achanger then

            tableau((i-1)*T_col'pos(T_col'last)+T_Col'pos(j)).Achanger := false;
            Grille(i+x, T_Col'val(T_Col'pos(j)+y)) := Grille(i,j);
            Grille(i, j) := vide;

          end if;
        end loop;
      end loop;
    end if;

    if Dir = hg or Dir = hd then
      for i in Grille'range(1) loop
        for j in Grille'range(2) loop
          if tableau((i-1)*T_col'pos(T_col'last)+T_Col'pos(j)).Achanger then

            tableau((i-1)*T_col'pos(T_col'last)+T_Col'pos(j)).Achanger := false;
            Grille(i+x, T_Col'val(T_Col'pos(j)+y)) := Grille(i,j);
            Grille(i, j) := vide;

          end if;
        end loop;
      end loop;
    end if;
  end MajGrille;



function Guerison(Grille : in TV_Grille) return boolean is
  --{} => {résultat = vrai si Grille(1,A) = Grille(2,B) = ROUGE}
begin
  return Grille(1,'A') = ROUGE AND Grille(2,'B') = ROUGE ;
end Guerison;


end p_virus;
