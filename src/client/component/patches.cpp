#include <std_include.hpp>
#include "loader/component_loader.hpp"

#include "game/game.hpp"
#include "game/dvars.hpp"

#include <utils/hook.hpp>
#include <utils/string.hpp>

namespace patches
{
	namespace
	{
		utils::hook::detour gscr_set_save_dvar_hook;
		utils::hook::detour dvar_register_float_hook;
		utils::hook::detour dvar_register_bool_hook;

		void* sub_46148()
		{
			static uint64_t off_11C52460 = 0x140AD0C58;
			return &off_11C52460;
		}

		DECLSPEC_NORETURN void quit_stub()
		{
			component_loader::pre_destroy();
			exit(0);
		}

		void gscr_set_save_dvar_stub()
		{
			const auto string = utils::string::to_lower(utils::hook::invoke<const char*>(0x1405C7C20, 0));
			if (string == "cg_fov" || string == "cg_fovscale" || string == "snd_musicdisabledforcustomsoundtrack")
			{
				return;
			}

			gscr_set_save_dvar_hook.invoke<void>();
		}

		game::dvar_t* cg_fov = nullptr;
		game::dvar_t* cg_fovScale = nullptr;

		game::dvar_t* dvar_register_float_stub(int hash, const char* dvarName, float value, float min, float max, unsigned int flags)
		{
			static const auto cg_fov_hash = game::generateHashValue("cg_fov");
			static const auto cg_fov_scale_hash = game::generateHashValue("cg_fovscale");

			if (hash == cg_fov_hash)
			{
				return cg_fov;
			}

			if (hash == cg_fov_scale_hash)
			{
				return cg_fovScale;
			}

			return dvar_register_float_hook.invoke<game::dvar_t*>(hash, dvarName, value, min, max, flags);
		}

		game::dvar_t* snd_musicDisabledForCustomSoundtrack = nullptr;

		game::dvar_t* dvar_register_bool_stub(int hash, const char* name, bool value, unsigned int flags)
		{
			static const auto snd_musicdisabledforcustomsoundtrack_hash = game::generateHashValue("snd_musicdisabledforcustomsoundtrack");

			if (hash == snd_musicdisabledforcustomsoundtrack_hash)
			{
				return snd_musicDisabledForCustomSoundtrack;
			}

			return dvar_register_bool_hook.invoke<game::dvar_t*>(hash, name, value, flags);
		}
	}

	class component final : public component_interface
	{
	public:
		void post_unpack() override
		{
			// Fix startup crashes
			utils::hook::set(0x140633080, 0xC301B0);
			utils::hook::set(0x140272F70, 0xC301B0);
			utils::hook::jump(0x140046148, sub_46148, true);

			utils::hook::jump(0x14064EF10, quit_stub, true);

			// Unlock fps in main menu
			utils::hook::set<BYTE>(0x1403D8E1B, 0xEB);

			// Disable battle net popup
			utils::hook::nop(0x1405F4496, 5);

			// Allow kbam input when gamepad is enabled
			utils::hook::nop(0x1403D2F8E, 2);
			utils::hook::nop(0x1403D0C9C, 6);

			// Prevent game from overriding cg_fov and cg_fovscale values
			gscr_set_save_dvar_hook.create(0x140504C60, &gscr_set_save_dvar_stub);

			// Make cg_fov and cg_fovscale saved dvars

			cg_fov = dvars::register_float("cg_fov", 65.f, 40.f, 200.f, 
				game::DVAR_FLAG_SAVED, "The field of view angle in degrees for client 0");
			cg_fovScale = dvars::register_float("cg_fovScale", 1.f, 0.1f, 2.f, 
				game::DVAR_FLAG_SAVED, "Scale applied to the field of view");

			// Make snd_musicDisabledForCustomSoundtrack saved dvar

			snd_musicDisabledForCustomSoundtrack = dvars::register_bool("snd_musicDisabledForCustomSoundtrack", 0, 
				game::DVAR_FLAG_SAVED, "Disable all in-game music");

			dvar_register_float_hook.create(game::Dvar_RegisterFloat.get(), dvar_register_float_stub);
			dvar_register_bool_hook.create(game::Dvar_RegisterBool.get(), dvar_register_bool_stub);
		}
	};
}

REGISTER_COMPONENT(patches::component)
