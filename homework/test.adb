with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
    Y : Integer := 7;
    Z : Integer;

    function F (X : in out Integer) return Integer is
    begin
        X := X + 1;
        Y := X;
        X := X + 1;
        return Y;
    end F;

    function G (X : in out Integer) return Integer is
    begin
        Y := F(X) + 1;
        X := F(Y) + 3;
        return X;
    end G;

begin
    Z := G(Y);
    Put_Line("Z: " & Integer'Image(Z));
    Put_Line("Y: " & Integer'Image(Y));
end Main;