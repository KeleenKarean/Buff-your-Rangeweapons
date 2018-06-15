//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_HolySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants holy avenger properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"


void  AddHolyAvengerEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(5), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,FALSE);
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyHolyAvenger(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
   return;
}

#include "x2_inc_toollib"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

   if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
    object oMySpellTarget   =  GetSpellTargetObject();
    object oRangeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMySpellTarget);
    object oGet04 = GetItemInSlot(INVENTORY_SLOT_ARROWS, oMySpellTarget);
    object oGet02 = GetItemInSlot(INVENTORY_SLOT_BOLTS, oMySpellTarget);
    object oGet03 = GetItemInSlot(INVENTORY_SLOT_BULLETS, oMySpellTarget);
    object oGet01 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMySpellTarget);


    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));

            AddHolyAvengerEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
        }
        TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(GetSpellTargetObject()), 4, 0.0f, 6.0f);
        DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUPER_HEROISM),GetLocation(GetSpellTargetObject())));

        return;
    }
            else
            {
            if(IPGetIsRangedWeapon(oRangeWeapon) )
            {
                SignalEvent(GetItemPossessor(oGet01), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                SignalEvent(GetItemPossessor(oGet02), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                SignalEvent(GetItemPossessor(oGet03), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                SignalEvent(GetItemPossessor(oGet04), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                if (nDuration>0)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oRangeWeapon));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oGet01), RoundsToSeconds(nDuration));
                    AddHolyAvengerEffectToWeapon(oGet01, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oGet02), RoundsToSeconds(nDuration));
                    AddHolyAvengerEffectToWeapon(oGet02, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oGet03), RoundsToSeconds(nDuration));
                    AddHolyAvengerEffectToWeapon(oGet03, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oGet04), RoundsToSeconds(nDuration));
                    AddHolyAvengerEffectToWeapon(oGet04, RoundsToSeconds(nDuration));
            }
                return;
            }
            else
        {
               FloatingTextStrRefOnCreature(83384, OBJECT_SELF);
               return;
    }
    }

}
