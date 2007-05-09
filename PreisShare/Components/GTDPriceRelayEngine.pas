unit GTDPriceRelayEngine;

interface

type
  TPriceRelayFactory = class(TObject)
  private
  public
    function isPLURelayed(const Product_Lookup : String):Boolean;
    function CalculateRelayedPrice(const Product_Lookup : String; var Actual_Price : Double):Boolean;

    function AddRelayedProduct(const Product_Lookup : String; Trader_ID : Integer; Product_Group : String):Boolean;
    function DeleteRelayedProduct(const Product_Lookup : String; Trader_ID : Integer; Product_Group : String):Boolean;

    procedure RecalculatePricelist;
    procedure ReDistributePricelist;
    procedure MarkPricelistAsChanged(TrueOrFalse : Boolean);
  end;

implementation

function TPriceRelayFactory.isPLURelayed(const Product_Lookup : String):Boolean;
begin
end;

function TPriceRelayFactory.CalculateRelayedPrice(const Product_Lookup : String; var Actual_Price : Double):Boolean;
begin
end;

procedure TPriceRelayFactory.RecalculatePricelist;
begin
end;

procedure TPriceRelayFactory.MarkPricelistAsChanged(TrueOrFalse : Boolean);
begin
end;

procedure TPriceRelayFactory.ReDistributePricelist;
begin
end;

function TPriceRelayFactory.AddRelayedProduct(const Product_Lookup : String; Trader_ID : Integer; Product_Group : String):Boolean;
begin
end;

function TPriceRelayFactory.DeleteRelayedProduct(const Product_Lookup : String; Trader_ID : Integer; Product_Group : String):Boolean;
begin
end;

end.
