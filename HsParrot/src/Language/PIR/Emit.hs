{-# LANGUAGE CPP #-}
module Language.PIR.Emit (
    Emit(..),
    nested, eqSep, commaSep,
) where
import Text.PrettyPrint

class (Show x) => Emit x where
    emit :: x -> Doc
    -- emit x = error ("Unrecognized construct: " ++ show x)

#if ! MIN_VERSION_pretty(1, 1, 2)
instance Eq Doc where
    x == y = (render x) == (render y)
#endif

instance Emit String where
    emit = text

instance (Emit a) => Emit [a] where
    emit = vcat . map emit

instance (Emit a) => Emit (Maybe a) where
    emit Nothing = empty
    emit (Just x) = emit x

instance Emit Doc where
    emit = id

instance Emit Int where
    emit = int

nested :: (Emit x) => x -> Doc
nested = nest 4 . emit

eqSep :: (Emit a, Emit b, Emit c) => a -> b -> [c] -> Doc
eqSep lhs rhs args = emit lhs <+> equals <+> emit rhs <+> commaSep args

commaSep :: (Emit x) => [x] -> Doc
commaSep = hsep . punctuate comma . map emit
