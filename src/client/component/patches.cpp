#include <std_include.hpp>
#include "loader/component_loader.hpp"

#include "game/game.hpp"
#include "game/dvars.hpp"

#include <utils/hook.hpp>

namespace patches
{
	namespace
	{
		utils::hook::detour pm_crashland_hook;

		void pm_crashland_stub(void* ps, void* pm)
		{
			if (dvars::jump_enableFallDamage->current.enabled)
			{
				pm_crashland_hook.invoke<void>(ps, pm);
			}
		}

		uint64_t off_11C52460;
		void* sub_46148()
		{
			off_11C52460 = game::base_address + 0xAD0C58;
			return &off_11C52460;
		}
		
		bool _true()
		{
			return true;
		}
	}

	class component final : public component_interface
	{
	public:
		void post_unpack() override
		{
			// Not sure but it works
			utils::hook::jump(game::base_address + 0x633080, _true, true);
			utils::hook::jump(game::base_address + 0x272F70, _true, true);
			utils::hook::jump(game::base_address + 0x46148, sub_46148, true);

			// Unlock fps in main menu
			utils::hook::set<BYTE>(game::base_address + 0x3D8E1B, 0xEB);

			// Disable battle net popup
			utils::hook::nop(game::base_address + 0x5F4496, 5);

			pm_crashland_hook.create(game::base_address + 0x688A20, pm_crashland_stub);
			dvars::jump_enableFallDamage = dvars::register_bool("jump_enableFallDamage", 1, game::DVAR_FLAG_REPLICATED);

			dvars::register_float("jump_height", 39, 0, 1000, game::DVAR_FLAG_REPLICATED);
			dvars::register_float("g_gravity", 800, 1, 1000, game::DVAR_FLAG_REPLICATED);
			dvars::register_int("g_speed", 190, 0, 1000, game::DVAR_FLAG_REPLICATED);

			dvars::register_bool("sf_use_martyr_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_precision_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_greenberet_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_slowmo", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_fortitude_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_desperation_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_polterghost_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_wolf_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_attraction_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_starvation_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_ignoreammo", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_pineapple_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_football_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_tire_explosion", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_clustergrenade", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_pomegrenade_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_pinata_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_chaplin", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_edge_mode", false, game::DVAR_FLAG_NONE);
			dvars::register_bool("sf_use_bw", false, game::DVAR_FLAG_NONE);
		}
	};
}

REGISTER_COMPONENT(patches::component)