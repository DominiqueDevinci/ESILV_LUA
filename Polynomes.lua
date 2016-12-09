-- Un polynome va être représenté par ses coefficient dans un array classique #
-- Exemple : 3x² + 1 : {1, 0, 3}



-- definition des opérateurs entre polynomes grace aux metatables ...

local metatable_polynome={};

function metatable_polynome.__add(p1, p2) -- definition de l'opérateur +
	local p=create_polynome({});
	local deg1,deg2=degre_polynome(p1),degre_polynome(p2);
	
	for i=1,math.min(deg1,deg2)+1,1 do
		p[i]=p1[i]+p2[i];
	end;
	if deg1~=deg2 then -- inutile et dangereux (boucle infinie) si les degrés sont les mêmes
		for i=math.min(deg1, deg2)+2,math.max(deg1,deg2)+1,1 do
			if deg1>deg2 then
				p[i]=p1[i];
			else
				p[i]=p2[i];
			end;
		end;
	end;
	return p;
end;

function metatable_polynome.__mul(p1, p2)
	
	-- on commence par créer un polynome en initialisant tous les coeffs à 0 (jusqu'au degré deg1*deg2)
	local deg1,deg2=degre_polynome(p1),degre_polynome(p2);
	local p=create_polynome({});
	
	for i=1,deg1+deg2+1,1 do
		p[i]=0;
	end;
	
	for d1,coeff1 in ipairs(p1) do -- d,c pour degré, coeff
		local tmp={};
		---- in initialise le polynome temporaire ...
		for i=1,deg1+deg2+1,1 do
			tmp[i]=0;
		end;
		--print("multiplicateur : "..coeff1.."^"..d1-1);
		--afficher_polynome(p2, 'z');
		for d2,coeff2 in ipairs(p2) do 
			
			local new_deg=d1+d2-2;
			--print("new_deg="..new_deg.." pour le coeff : "..coeff1*coeff2);
			tmp[new_deg+1]=coeff1*coeff2;
		end;
		--afficher_polynome(tmp, 'y');
		p=p+tmp;
	end;
	return p;
end;

function metatable_polynome.__sub(p1, p2)
	return p1+(p2*{-1});
end;

function create_polynome(tab)
	setmetatable(tab, metatable_polynome);
	return tab;
end;

function afficher_polynome(p, variable) 
	local str="";
	local first=true;

	for k, v in ipairs(p) do
		if(v~=0) then
			if(v<0) then
				-- str=str.."-"..v;
				-- pas besoin de rajouter le moins car il est deja affiché ...
				str=str..v;
			else
				if(first==false) then
					str=str.."+";
				end;
				str=str..v;
			end;
			first=false;
			
			-- on oublie pas de traiter la puissance
			if(k==2) then -- si deg==1
				str=str..variable..' ';
			elseif (k>2) then
				str=str..variable.."^"..(k-1).." ";
			end;
		end; -- sinon on affiche pas ...
	end; -- end for
	
	print(str);
	
end;



function degre_polynome(p)
	-- on vérifie que les coefficients dominants ne soient pas nulls ...
	for i=#p,1,-1 do
		if p[i]==0 then
			table.remove(p, i);
		else
			break; -- si le coeff dominant n'est pas null on arrete la !
		end;
	end;
	return #p-1; -- en lua # est l'opérateur unaire renvoyant la longeur de d'une chaine ou d'un table ...
end;

function test(p) 
	p[1]=2;
	p[2]=3;
	p[3]=4;
end;

function infos_polynome(p, title) -- fonction affichant le polynome et des infos à son propos
	print("\n************           "..title.."            **********");
	afficher_polynome(p, 'x');
	print("Degre : "..degre_polynome(p));
end;
-- polynome de test : {1, 0, 2, 0, -4}

local p1=create_polynome({1, 0, 2, 0, -4}); -- ne fait qu'un setmetatable sur le tableau ....
local p2=create_polynome({0, 2, 1, 0, 0, 0});

infos_polynome(p1, "P1"); -- 1+2x^2 -4x^4
infos_polynome(p2, "P2"); -- 2x +1x^2
infos_polynome(p1-p2, "P1-P2"); -- 1-2x +1x^2 -4x^4
infos_polynome(p1+p2, "P1+P2"); -- 1+2x +3x^2 -4x^4
infos_polynome(p1*p2, "P1*P2"); -- 2x +1x^2 +4x^3 +2x^4 -8x^5 -4x^6


