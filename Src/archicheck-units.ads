-- -----------------------------------------------------------------------------
-- ArchiCheck, the software architecture compliance verifier
-- Copyright (C) 2005, 2006, 2009 - Lionel Draghi
-- This program is free software;
-- you can redistribute it and/or modify it under the terms of the GNU General
-- Public License Versions 3, refer to the COPYING file.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Package: Archicheck.Units specification
-- Purpose:
--   This package defines a Unit and the Unit_List, and manage the list
--   of dependencies found while analyzing sources AND the rules files.
--
-- Effects:
--
-- Limitations:
--
-- Performance:
--
-- -----------------------------------------------------------------------------

with Archicheck.Sources;

with Ada.Containers.Doubly_Linked_Lists;
-- with Ada.Strings.Hash;
with Ada.Strings.Unbounded;

private package Archicheck.Units is

   -- --------------------------------------------------------------------------
   -- Unit_Kind are :
   -- 1. compilation units, common to more languages, like Packages, or
   --    specific to a language, like Protected records for Ada;
   -- 2. virtual units (aka Components), that is units declared in rules
   --    files.
   type Unit_Kind is (Package_K,
                      Procedure_K,
                      Function_K,
                      Task_K,
                      Protected_K,
                      Class_K,
                      Interface_K,
                      Component,
                      Unknown) with Default_Value => Unknown;
   function Image (Kind : Unit_Kind) return String;

   subtype Unit_Name is Ada.Strings.Unbounded.Unbounded_String;

   type Dependency is record
      To_Unit : Unit_Name;
      -- File & Line : where the dependency comes from
      File    : Ada.Strings.Unbounded.Unbounded_String;
      Line    : Natural;
   end record;
   -- --------------------------------------------------------------------------
   function Location_Image (Dep : Dependency) return String;

   -- --------------------------------------------------------------------------
   package Dependency_Lists is new Ada.Containers.Doubly_Linked_Lists
     (Dependency, "=");
   -- --------------------------------------------------------------------------
   function Unit_List_Image (List : Dependency_Lists.List) return String;

   -- --------------------------------------------------------------------------
   type Unit_Attributes (Kind : Unit_Kind := Unknown) is record
      Name : Unit_Name;
      case Kind is
         when Package_K .. Interface_K =>
            Lang           : Sources.Language;
            Implementation : Boolean;
            -- False if Specification, or Interface,
            -- True if implementation (or body, etc.)
         when Unknown | Component =>
            null;
      end case;
   end record;

   subtype Component_Attributes is Unit_Attributes (Kind => Component);

   -- --------------------------------------------------------------------------
   type Relationship is record
      From_Unit    : Unit_Attributes;
      Dependencies : Dependency_Lists.List;
   end record;
   -- --------------------------------------------------------------------------
   package Relationship_Lists is new Ada.Containers.Doubly_Linked_Lists
     (Relationship, "=");
   Relationship_List : Relationship_Lists.List;

   -- --------------------------------------------------------------------------
   -- Function Unit_Description
   -- Purpose:
   --   Return a string describing the unit, depending on the language.
   --   It can be "package body" for Ada
   --   or "interface" for Java
   -- Exceptions:
   --   None
   -- --------------------------------------------------------------------------
   function Unit_Description (U : in Unit_Attributes) return String;

   -- --------------------------------------------------------------------------
   -- Function: Is_Unit_In
   -- Purpose:
   --   Return True if Unit is equal to Component or is a child package of
   --   component.
   --   Note that the comparison is case insensitive.
   --   Exemples :
   --     Interfaces.C is     in Interfaces
   --     Interfaces.C is     in INTERFACES
   --     Interfaces.C is     in Interfaces.C
   --     Interfaces.C is not in Interfaces.C.Utilities
   --     Interfaces.C is not in Interfaces.Com
   -- Exceptions:
   --   None
   -- -------------------------------------------------------------------------
   function Is_A_Child (Unit      : String;
                        Component : String) return Boolean;

--     -- --------------------------------------------------------------------------
--     type Dependency is record
--        From : Unit;
--        To   : Unit;
--     end record;
--     package Dependency_Lists is new Ada.Containers.Doubly_Linked_Lists (Dependency);

   -- --------------------------------------------------------------------------
   -- Function: Get_List
   -- Purpose:
   --   Returns the whole list of dependencies known at that time.
   --
   -- Exceptions:
   --   None
   -- --------------------------------------------------------------------------
   -- function Get_List return Dependency_Lists.List;

   -- procedure Append (Dep : Dependency);

   -- --------------------------------------------------------------------------
   -- Procedure: Dump
   -- Purpose:
   --   Put all dependencies known at call time, one per line, in the following
   --   format :
   --   > P4 specification depends on P5
   --
   -- Exceptions:
   --   None
   -- --------------------------------------------------------------------------
   procedure Dump;

   -- --------------------------------------------------------------------------
   procedure Add_Unit (Unit         : Unit_Attributes;
                       Dependencies : Dependency_Lists.List);

   -- --------------------------------------------------------------------------
   procedure Add_Component (Component    : Component_Attributes;
                            Dependencies : Dependency_Lists.List);

   -- --------------------------------------------------------------------------
   function Is_Unit_In_Component (Unit      : String;
                                  Component : String) return Boolean;

-- private

   -- function Hash (Key : Unit_Attributes) return Ada.Containers.Hash_Type;
   -- --------------------------------------------------------------------------
--     package Unit_Maps is new Ada.Containers.Indefinite_Hashed_Maps
--       (Key_Type        => String, -- Unit_Attributes, --
--        Element_Type    => Dependency, -- Unit_Attributes, -- Dependency_Lists.List, --
--        Hash            => Ada.Strings.Hash, -- Hash,
--        Equivalent_Keys => "=",
--        "="             => "="); -- Dependency_Lists."=");
--     Unit_Map : Unit_Maps.Map; --** à déplacer dans le body

end Archicheck.Units;
