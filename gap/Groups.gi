#############################################################################
##
##  Groups.gi                                                 Blocks package
##
##  Copyright 2013,      Mohamed Barakat, University of Kaiserslautern
##
##  Implementation stuff for groups.
##
#############################################################################

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( IsReal,
        [ CategoryCollections(IsMultiplicativeElementWithInverse) and
          IsExternalSet ],
        
  function( K )
    
    ## this is efficient by a special method for =
    return K = Involution( K );
    
end );

##
InstallMethod( SerreCharacteristicSubgroup,
        [ IsGroup ],
        
  function( G )
    local L;
    
    L := List( G );
    
    ## this naive procedure is enough for our small group orders
    return Subgroup( G, Concatenation(
                   List( L, g -> g^2 ),
                   Filtered( L, g -> Order( g ) = 2 )
                   ) );
    
end );

##
InstallMethod( SerreFactorGroup,
        [ IsGroup ],
        
  function( G )
    
    return G / SerreCharacteristicSubgroup( G );
    
end );

##
InstallMethod( ConjugacyClassesOfNormalSubgroup,
        [ IsGroup and HasParentAttr ],
        
  function( N )
    local G, KK;
    
    G := Parent( N );
    
    KK := ConjugacyClasses( G );
    
    return Filtered( KK, K -> Representative( K ) in N );
    
end );

##
InstallMethod( ConjugacyClassesOfComplementOfNormalSubgroup,
        [ IsGroup and HasParentAttr ],
        
  function( N )
    local G, KK;
    
    G := Parent( N );
    
    KK := ConjugacyClasses( G );
    
    return Difference( KK, ConjugacyClassesOfNormalSubgroup( N ) );
    
end );

##
InstallMethod( ConjugacyInvolutoryClassesOfComplementOfNormalSubgroup,
        [ IsGroup and HasParentAttr ],
        
  function( N )
    local KK;
    
    KK := ConjugacyClassesOfComplementOfNormalSubgroup( N );
    
    KK := List( KK,
                function( K )
                  local iK;
                  iK := Involution( K );
                  if K = iK then
                      return [ K ];
                  else
                      return Set( [ K, iK ] );
                  fi;
                end );
    
    return Set( KK );
    
end );

####################################
#
# methods for operations:
#
####################################

##  <#GAPDoc Label="IsRegular_code">
##  <Listing Type="Code"><![CDATA[
InstallMethod( IsRegular,
        [ IsMultiplicativeElementWithInverse, IsInt ],
        
  function( g, p )
    
    if not IsPrime( p ) then
        Error( "the second argument must be a prime\n" );
    fi;
    
    return Gcd( Order( g ), p ) in [ 1, -1 ];
    
end );
##  ]]></Listing>
##  <#/GAPDoc>

##
InstallMethod( IsRegular,
        [ CategoryCollections(IsMultiplicativeElementWithInverse), IsInt ],
        
  function( K, p )
    local g;
    
    g := Representative( K );
    
    return IsRegular( g, p );
    
end );

##  <#GAPDoc Label="DefectGroup_code:cc">
##  <Listing Type="Code"><![CDATA[
InstallMethod( DefectGroup,
        [ CategoryCollections(IsMultiplicativeElementWithInverse), IsInt ],
        
  function( K, p )
    local G, g;
    
    if not IsPrime( p ) then
        Error( "the second argument must be a prime\n" );
    fi;
    
    G := ActingDomain( K );
    g := Representative( K );
    
    return SylowSubgroup( Centralizer( G, g ), p );
    
end );
##  ]]></Listing>
##  <#/GAPDoc>

##
InstallMethod( Involution,
        [ CategoryCollections(IsMultiplicativeElementWithInverse) ],
        
  function( K )
    local G, g;
    
    G := ActingDomain( K );
    g := Representative( K );
    
    return ConjugacyClass( G, g^-1 );
    
end );

##
InstallMethod( Coefficient,
        [ IsElementOfFreeMagmaRing, IsMultiplicativeElementWithInverse ],
        
  function( b, g )
    local coeffs, pos;
    
    coeffs := CoefficientsAndMagmaElements( b );
    
    pos := Position( coeffs, g );
    
    if pos = fail then
        return Zero( coeffs[2] );
    fi;
    
    return coeffs[pos + 1];
    
end );

##
InstallMethod( Coefficient,
        [ IsElementOfFreeMagmaRing, CategoryCollections(IsMultiplicativeElementWithInverse) ],
        
  function( b, K )
    
    return Coefficient( b, Representative( K ) );
    
end );

##
InstallMethod( Coefficients,
        [ IsElementOfFreeMagmaRing ],
        
  function( b )
    local modtbl, classes;
    
    modtbl := UnderlyingBrauerTable( b );
    
    classes := ConjugacyClasses( OrdinaryCharacterTable( modtbl ) );
    
    return List( classes, K -> Coefficient( b, K ) );
    
end );

##
InstallMethod( ConjugacyInvolutoryClassesOfComplementOfNormalSubgroup,
        [ IsAlgebra, IsGroup and HasParentAttr ],
        
  function( kG, N )
    local KK, o;
    
    KK := ConjugacyInvolutoryClassesOfComplementOfNormalSubgroup( N );
    
    KK := List( KK, s -> List( s, List ) );
    
    o := One( kG );
    
    return List( KK, k -> List( List( k, g -> o * g ), Sum ) );
    
end );
