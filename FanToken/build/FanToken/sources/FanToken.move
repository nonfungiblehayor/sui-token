module fanToken::FanToken {

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
        decimal: u8,
        name: string::String,
        symbol: ascii::String,
    }

    struct TreasuryCap<phantom T> has key, store {
        id: UID,
        total_supply: Supply<T>
    }

    struct CurrencyCreated<phantom T> has copy, drop {
        decimila: u8
    }
}