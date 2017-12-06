-- DONALD TRAN
-- AU USER ID: DZT0021
-- DATE: 23 APRIL 2017
-- CLASS: COMP 3220

-------------------------------------------------------------------------------
--		           [Sources Used]				     --				   
-- (1) Base Conversion Algorithms - 				             --							   
--     http://www.cs.trincoll.edu/~ram/cpsc110/inclass/conversions.html	     --		   
-- (2) N-bit Binary Addition Algorithm - 		   		     --
--     http://chortle.ccsu.edu/assemblytutorial/Chapter-08/ass08_3.html	     --		   
-- (3) Binary Subtraction						     --
--     https://courses.cs.vt.edu/~cs1104/BuildingBlocks/arithmetic.040.html  --		   
-------------------------------------------------------------------------------


with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Random;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

procedure Main is

   subtype BINARY_NUMBER is Integer range 0..1;
   type BINARY_ARRAY is array(0 .. 15) of BINARY_NUMBER;
   
   package My_Random is new Random(FLOAT);
   use My_Random;
   	
   	-- [ Arrays filled with random binary numbers ] --
   Random_Array_1 : BINARY_ARRAY;
   Random_Array_2 : BINARY_ARRAY;
   Random_Array_3 : BINARY_ARRAY;
   
           -- [ Function Declartions ] --	
   function Bin_To_Int (Binary: in BINARY_ARRAY) return INTEGER;
   function Int_To_Bin(Number: in Integer) return BINARY_ARRAY;
   function "+"(Top: BINARY_ARRAY; Bottom: BINARY_ARRAY) return BINARY_ARRAY;
   function "+"(Top: Integer; Bottom: BINARY_ARRAY) return BINARY_ARRAY;
   function "+"(Top: BINARY_ARRAY; Bottom: Integer) return BINARY_ARRAY;
   function "-"(Min_End: BINARY_ARRAY; Sub_End: BINARY_ARRAY) return BINARY_ARRAY;
   function "-"(Min_End: Integer; Sub_End: BINARY_ARRAY) return BINARY_ARRAY;
   function "-"(Min_End: BINARY_ARRAY; Sub_End: Integer) return BINARY_ARRAY;
   
       -- [ Procedure Declarations ] --
   procedure Reverse_Bin_Arr(Swap: in out BINARY_ARRAY);
   procedure Print_Bin_Arr(Print: in BINARY_ARRAY);
   procedure Fill(Array_In: in out BINARY_ARRAY);
  
   ---------------------------------------------------
   -- Takes a binary number and converts to base_10 --  
   ---------------------------------------------------
   function Bin_To_Int (Binary: in BINARY_ARRAY) return INTEGER is
      Result:INTEGER;
      N: INTEGER;
   begin
      Result := 0;
      N	  := 15;
      for i in 0..15 loop
         Result := Result + (Binary(i)*(2**N));
         N := (N-1);           
      end loop;
      return Result;
   end Bin_To_Int;

   ---------------------------------------------------
   --  Takes a base_10 value and converts to binary -- 
   ---------------------------------------------------
   function Int_To_Bin(Number: in Integer) return BINARY_ARRAY is
      Return_Array : BINARY_ARRAY;
      Div : Integer;
      N : Integer;
      Base : Integer;
      Remainder : Boolean;
      Left_Most : Integer;
      R : BINARY_NUMBER;
   begin
      N := Number;
      Left_Most := 15;
      Base := 2;
      for i in reverse 0 .. 15 loop
         Remainder := ((N mod Base) /= 0);
         Div := (N / Base);
         N := Div;
         if Remainder = true then
            R := 1;
         else
            R := 0;
         end if;
         Return_Array(i) := R;
      end loop;
      return Return_Array;                          
   end Int_To_Bin;        
   
   ---------------------------------------------------------------------
   --  Adds two binary arrays and returns the resulting binary array  --
   ---------------------------------------------------------------------   
   function "+"(Top: BINARY_ARRAY; Bottom: BINARY_ARRAY) return BINARY_ARRAY is
      Return_Array : BINARY_ARRAY;
      Carry : BINARY_NUMBER;
      Column_Sum : Integer;
   begin
      Carry := 0;
      for i in reverse 0 .. 15 loop
         Column_Sum := Top(i) + Bottom(i) + Carry;
         if Column_Sum = 0 or Column_Sum = 1 then
            Carry := 0;
            Return_Array(i) := Column_Sum;
         else
            Carry := 1;
            Return_Array(i) := Column_Sum - 2;
         end if;
      end loop;
      return Return_Array;
   end "+";
   
   -----------------------------------------------------------------------------
   -- Accepts a base_10 value & a binary array and returns added binary array --
   -----------------------------------------------------------------------------   
   function "+"(Top: Integer; Bottom: BINARY_ARRAY) return BINARY_ARRAY is
   	  Top_To_Binary : BINARY_ARRAY;
   	  Return_Array: Binary_ARRAY;
   Begin
   	  Top_To_Binary := Int_To_Bin(Top);
   	  Return_Array := Top_To_Binary + Bottom;
   	  return Return_Array;
   end "+"; 

   -----------------------------------------------------------------------------
   -- Accepts a random array & a base_10 Value and returns added binary array --
   -----------------------------------------------------------------------------   
   function "+"(Top: BINARY_ARRAY; Bottom: Integer) return BINARY_ARRAY is
   	  Bottom_To_Binary : BINARY_ARRAY;
   	  Return_Array: Binary_ARRAY;
   Begin
   	  Bottom_To_Binary := Int_To_Bin(Bottom);
   	  Return_Array := Bottom_To_Binary + Top;
   	  return Return_Array;
   end "+"; 

      
   
   ----------------------------------------------------------------------
   --  Subtracts two binary arrays and returns binary array result     --
   ---------------------------------------------------------------------- 
   function "-"(Min_End: BINARY_ARRAY; Sub_End: BINARY_ARRAY) return BINARY_ARRAY is
   	  Return_Array : BINARY_ARRAY;
   	  Comp_Array: BINARY_ARRAY;
   	  Carry : BINARY_NUMBER;
   	  End_Around : BINARY_NUMBER;
   	  Column_Sum : Integer;
   Begin
   	  Carry := 0;
   	  End_Around := 1;
         -- 1st Loop creates complemented subtrahend --
      for i in 0 .. 15 loop
   	     if Sub_End(i) = 1 then
   	        Comp_Array(i) := 0;
   	     else 
   	        Comp_Array(i) := 1;
   	     end if;
   	  end loop;
   	     -- 2nd Loop does binary addition and adds End_Around if needed --
      for i in reverse 0 .. 15 loop
         Column_Sum := Min_End(i) + Comp_Array(i) + Carry;
         if Column_Sum = 0 or Column_Sum = 1 then
            Carry := 0;
            Return_Array(i) := Column_Sum;
         else
            Carry := 1;
            Return_Array(i) := Column_Sum - 2;
         end if;
      end loop;
      if Carry = End_Around then
      	Return_Array := Return_Array + End_Around;
      end if;
      return Return_Array;
   end "-";
   
   --------------------------------------------------------------------------------
   --  Subtracts base_10 Integer from binary array returns binary array result   --
   --------------------------------------------------------------------------------
   function "-"(Min_End: Integer; Sub_End: BINARY_ARRAY) return BINARY_ARRAY is
      Return_Array : BINARY_ARRAY;
      Min_To_Binary : BINARY_ARRAY;
   Begin   
      Min_To_Binary := Int_To_Bin(Min_End);
      Return_Array := Min_To_Binary - Sub_End;
      return Return_Array;
   end "-";
   
   --------------------------------------------------------------------------------
   --  Subtracts binary array from base_10 Integer returns binary array result   --
   --------------------------------------------------------------------------------
   function "-"(Min_End: BINARY_ARRAY; Sub_End: Integer) return BINARY_ARRAY is
      Return_Array : BINARY_ARRAY;
      Sub_To_Binary : BINARY_ARRAY;
   Begin   
      Sub_To_Binary := Int_To_Bin(Sub_End);
      Return_Array := Min_End - Sub_To_Binary;
      return Return_Array;
   end "-"; 
   
   -------------------------------------
   --  Reverses a binary array  --
   ------------------------------------- 
   procedure Reverse_Bin_Arr(Swap: in out BINARY_ARRAY) is
   Val: BINARY_NUMBER;
   begin
      for i in 0 .. 7 loop
         Val := Swap(i);
         Swap(i) := Swap(15 - i);
         Swap(15 - i) := Val;
      end loop;
   end Reverse_Bin_Arr;

   
   -------------------------------------
   --  Prints Binary Array to Console --
   -------------------------------------    
   procedure Print_Bin_Arr(Print: in BINARY_ARRAY) is
   begin
      for i in 0 .. 15 loop
         Put("[");
         Put(Print(i), Width => 1);
         Put("]");
      end loop;
      New_Line(1);
   end Print_Bin_Arr;
   
   -------------------------------------
   --  Creates a random Binary Array  --
   ------------------------------------- 
   procedure Fill(Array_In: in out BINARY_ARRAY) is
   begin
      for i in 0..15 loop
        Random_Array_1(i) := BINARY_NUMBER(FLOAT(Random_Number) * FLOAT(1));
      end loop;
   end Fill;
   
begin -- Start of procedure Main

   Set_Seed;
   
   Fill(Random_Array_1);
   New_Line(2);
   Put_Line("====================================================================="); 
   Put("A Filled Random Binary Array is: ");
   New_Line(1);
   Print_Bin_Arr(Random_Array_1);
   Put("The Integer representation of the binary array is: ");
   Put(Bin_To_Int(Random_Array_1), Width => 2);
   New_Line(2);
   
   Put_Line("=====================================================================");
   Put("A Second Binary Array we'll use for arithmetic is: ");
   Random_Array_2 := Int_To_Bin(1000);
   New_Line(1);
   Print_Bin_Arr(Random_Array_2);
   Put("The Integer representation of the second binary array is: ");
   Put(Bin_To_Int(Random_Array_2), Width => 2);
   New_Line(2);
   
   Put_Line("=====================================================================");
   Put("Adding both binary values together produces "); 
   Put("the following binary array: ");
   Random_Array_3 := Random_Array_1 + Random_Array_2;
   New_Line(1);
   Print_Bin_Arr(Random_Array_3);
   Put("The Integer representation for the two combined arrays is: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);

   Put_Line("====================================================================="); 
   Put("Adding the integer value of the first arrray "); 
   Put("to the binary value of ");
   New_Line(1);
   Put("the second array produces: ");
   Random_Array_3 := (Bin_To_Int(Random_Array_1) + Random_Array_2);
   Print_Bin_Arr(Random_Array_3);
   Put("The Integer representation for the two combined arrays is: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);
   
   Put_Line("=====================================================================");
   Put("Adding the binary value of the first arrray "); 
   Put("to the integer value of ");
   New_Line(1);
   Put("the second array produces: ");
   Random_Array_3 := (Random_Array_1 + Bin_To_Int(Random_Array_2));
   Print_Bin_Arr(Random_Array_3);
   Put("The Integer representation for the two combined arrays is: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);     
   
   Put_Line("=====================================================================");
   Put("Subtracting the second binary array from the first produces ");
   Put("the following ");
   New_Line(1);
   Put("binary array: ");
   Random_Array_3 := Random_Array_1 - Random_Array_2;
   Print_Bin_Arr(Random_Array_3);
   Put("The Integer representation for the subtracted array is: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);
   
   Put_Line("=====================================================================");
   Put("Subtracting the integer value of the second array "); 
   Put("from the binary value of ");
   New_Line(1);
   Put("the first array produces: ");
   Random_Array_3 := (Random_Array_1 - Bin_To_Int(Random_Array_2));
   Print_Bin_Arr(Random_Array_3);
   Put("The Integer representation for the two subtracted arrays is: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);
   
   Put_Line("====================================================================="); 
   Put("Subtracting the binary value of the second array "); 
   Put("from the integer value of ");
   New_Line(1);
   Put("the first array produces: ");
   Random_Array_3 := (Bin_To_Int(Random_Array_1) - Random_Array_2);
   Print_Bin_Arr(Random_Array_3);
   Put("The Integer representation for the two subtracted arrays is: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);   
   
   Put_Line("====================================================================="); 
   Put("If we want to reverse the order of the subtracted array, ");
   Put("it will produce ");
   New_Line(1);
   Put("the following array: ");
   Reverse_Bin_Arr(Random_Array_3);
   Print_Bin_Arr(Random_Array_3);
   Put("If we convert the reversed array to an integer value, ");
   New_Line(1);
   Put("it produces the following number: ");
   Put(Bin_To_Int(Random_Array_3), Width => 2);
   New_Line(2);
   Put_Line("=====================================================================");  
   
end Main;
