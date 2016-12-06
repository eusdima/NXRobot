classdef rewindClass < handle
   properties
      List;
      time = 0;
      increment=50;
   end
   methods
      function obj = add(obj,X)
         obj.List = [ obj.List, -X ]; % add {x,y} to List
         obj.time = obj.time + obj.increment;
         return;
      end
      function [X,Y] = pop(obj)
          size = rewindClass.size(obj);
          if ( sizee >= 2 )
              obj.time = obj.time - obj.increment;
              Y = obj.List(size);
              obj.List(size) = [];
              X = obj.List(size-1);
              obj.List(size-1) = [];
              return;
          else
              X='null';
              return;
          end
      end
      function width = size(obj)
         [height, width] = size(obj.List);
         return;
      end
   end
   methods(Static)
       function result = canRewind(obj)
          result = false;
          if ( rewindClass.size(obj) > 1 )
              result = true;
          end
          return;
       end
   end
end