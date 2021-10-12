
data Falsifiable a where
    Falsi :: b -> Not a -> Falsifiable a

data Sat a where
    Sat :: b -> a -> Sat a

data Interesting a = Interest (Falsifiable a) (Sat a)
    