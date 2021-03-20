classdef EKM
	%EKM Egykerékmodell
	
	properties (Constant)
		
		% Kezdeti értékek
		v_0 = 20;
		w_0 = EKM.v_0/EKM.R_K;
		
		% Méretek
		m = 1000;					% [kg]
		g = 9.81;					% [N/kg] = [m/s^2]
		
		% Kerék
		R_K = 0.35;					% [m]
		J_K = 1.5;					% [N m/(rad/s^2)] = [kg m^2]
		B_H = 1;					% [N m/(rad/s)]
		
		% Légellenállás
		c_W = 0.3;
		rho_L = 1.2;				% [kg/m^3]
		A_0 = 2;					% [m^2]
		
		% Fékrendszer ...
		T_ABS = 10e-3;				% [s]
		
		T_D = 10e-3;				% [s], fékholtidő
		C_q = 1.4;					% [cm^3/(s*sqrt(kPa))]
		V_0 = 0.59;					% [cm^3], haszontalan térfogat
		
		p_V0 = 762;					% [kPa]
		p_V1 = 2;
		p_V2 = 1.41;
		p_V3 = 0.097;
		
		A_F = 4e-4;					% [m^2], a fékmunkahenger keresztmetszete
		mu_F = 1;					% A súrlódási tényező a tárcsa és a pofák között
		R_F = 0.2;					% [m], a féktárcsa átlagos sugara
		
		p_0 = 20000;				% [kPa]
	end
	
	methods (Static)
		
		function mu_x = Pacejka(s_x)
			% Száraz aszfalt
			B = 3.76;
			C = 2.7;
			D = 1;			% mu_max
			E = 1;
			
			% Magic formula
			mu_x = D * sin( ...
				C * atan( ...
					B * ( (1-E)*s_x + E/B * atan(B*s_x) ) ...
					) ...
				);
		end
		
		function PacejkaTest()
			s_x = -1:0.05:1;
			
			figure(156); hold on;
			title('Pacejka, \mu_x(s_x)');
			
			plot(s_x, EKM.Pacejka(s_x), 'LineWidth', 3);
		end
		
		function m_f = M_F(w, M, M_F0)
			if w ~= 0
				% A kerék még forgásban van
				m_f = -sign(w) * M_F0;
			else
				% A kerék nem forog
				if abs(M) > M_F0
					m_f = -sign(M) * M_F0;
				else
					m_f = -M;
				end
			end
		end
		
		function p = BrakePressureModel(V)
			if V > EKM.V_0
				p = EKM.p_V0 * ( ...
					V - EKM.p_V1 * (1 - exp( ...
						-(V - EKM.p_V3) / EKM.p_V2 ...
						)) ...
					);
			else
				p = 0;
			end
		end
		
	end
	
end

