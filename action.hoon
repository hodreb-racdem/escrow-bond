::  Action (you can call it anything) is the type mold that calldata must fit.
::  This contract permits 4 actions, shown here
::
::  First -> a bond is created with %new-bond. 
::  Second -> anyone can %deposit the proper asset. 
::  Third -> The designated custodian address can %award funds in the 
::  bond however they desire, as long as it happens before the timelock.
::  Fourth -> after the timelock (represented in ETH block height) is up, if %award 
::  has not been performed, anyone can call %release to return all deposited
::  funds to their original depositors.

+$  action
  $%  ::  create a new bond held by this contract.
      ::  sets escrow asset but not amount or depositors
      [%new-bond custodian=address timelock=@ud asset-metadata=id]
      ::  become a depositor in a bond -- caller must first
      ::  set appropriate allowance for this contract
      [%deposit bond-id=id amount=@ud account=id]
      ::  as a custodian, award tokens held in escrow to chosen address
      ::  total amount awarded *must* add up to amount of tokens held
      ::  note that addresses do *not* need to have been depositors
      [%award bond-id=id to=(list [=address amount=@ud account=(unit id)])]
      ::  anyone can submit -- returns all funds to depositors
      ::  if the bond's timelock has passed and tokens have not
      ::  been awarded.
      [%release bond-id=id]
  ==
