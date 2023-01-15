module sui::fanToken {
    use std::string;
    use std::ascii;
    use std::option::{Self, Option};
    use sui::balance::{Self, Balance, Supply};
    use sui::tx_context::TxContext;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::url::{Self, Url};
    use std::vector;
    use sui::event;

     const EBadWitness: u64 = 0;

     const EInvalidArg: u64 = 1;

     const ENotEnough: u64 = 2;

     struct Coin<phantom T> has key, store {
        id: UID,
        balance: Balance<T>
    }

    struct CoinMetadata<phantom T> has key, store {
        id: UID,
        decimals: u8,
        name: string::String,
        symbol: ascii::String,
        description: string::String,
        icon_url: Option<Url>
    }

    struct TreasuryCap<phantom T> has key, store {
        id: UID,
        total_supply: Supply<T>
    }

    struct CurrencyCreated<phantom T> has copy, drop {
        decimals: u8
    }

    public fun total_supply<T>(cap: &TreasuryCap<T>): u64 {
        balance::supply_value(&cap.total_supply)
    }

    public fun treasury_into_supply<T>(treasury: TreasuryCap<T>): Supply<T> {
        let TreasuryCap { id, total_supply } = treasury;
        object::delete(id);
        total_supply
    }

    public fun supply<T>(treasury: &mut TreasuryCap<T>): &Supply<T> {
        &treasury.total_supply
    }

    public fun supply_mut<T>(treasury: &mut TreasuryCap<T>): &mut Supply<T> {
        &mut treasury.total_supply
    }

    public fun value<T>(self: &Coin<T>): u64 {
        balance::value(&self.balance)
    }

    public fun balance<T>(coin: &Coin<T>): &Balance<T> {
        &coin.balance
    }

    public fun balance_mut<T>(coin: &mut Coin<T>): &mut Balance<T> {
        &mut coin.balance
    }

    public fun from_balance<T>(balance: Balance<T>, ctx: &mut TxContext): Coin<T> {
        Coin { id: object::new(ctx), balance }
    }

    public fun into_balance<T>(coin: Coin<T>): Balance<T> {
        let Coin { id, balance } = coin;
        object::delete(id);
        balance
    }

    public fun mint<T>(
        cap: &mut TreasuryCap<T>, value: u64, ctx: &mut TxContext,
    ): Coin<T> {
        Coin {
            id: object::new(ctx),
            balance: balance::increase_supply(&mut cap.total_supply, value)
        }
    }

    public fun mint_balance<T>(
        cap: &mut TreasuryCap<T>, value: u64
    ): Balance<T> {
        balance::increase_supply(&mut cap.total_supply, value)
    }

    public fun burn<T>(cap: &mut TreasuryCap<T>, c: Coin<T>): u64 {
        let Coin { id, balance } = c;
        object::delete(id);
        balance::decrease_supply(&mut cap.total_supply, balance)
    }

    public entry fun mint_and_transfer<T>(
        c: &mut TreasuryCap<T>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        transfer::transfer(mint(c, amount, ctx), recipient)
    }

    public fun get_decimals<T>(
        metadata: &CoinMetadata<T>
    ): u8 {
        metadata.decimals
    }

    public fun get_name<T>(
        metadata: &CoinMetadata<T>
    ): string::String {
        metadata.name
    }

    public fun get_symbol<T>(
        metadata: &CoinMetadata<T>
    ): ascii::String {
        metadata.symbol
    }

    public fun get_description<T>(
        metadata: &CoinMetadata<T>
    ): string::String {
        metadata.description
    }

    public fun get_icon_url<T>(
        metadata: &CoinMetadata<T>
    ): Option<Url> {
        metadata.icon_url
    }

}