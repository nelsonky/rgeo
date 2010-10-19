# -----------------------------------------------------------------------------
# 
# Mercator geography common method definitions
# 
# -----------------------------------------------------------------------------
# Copyright 2010 Daniel Azuma
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder, nor the names of any other
#   contributors to this software, may be used to endorse or promote products
#   derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# -----------------------------------------------------------------------------
;


module RGeo
  
  module Geography
    
    module SimpleMercator
      
      
      module GeometryMethods
        
        
        def eql?(rhs_)
          if rhs_.respond_to?(:factory) && rhs_.factory.eql?(@factory)
            projection.eql?(rhs_.projection)
          else
            false
          end
        end
        
        
        def srid
          4326
        end
        
        
        def projection
          unless @projection
            projection_factory_ = @factory.projection_factory
            if projection_factory_
              @projection = _make_projection(projection_factory_)
            else
              @projection = nil
            end
            @projection = false unless @projection
          end
          @projection ? @projection : nil
        end
        
        
        def _make_projection(projection_factory_)  # :nodoc:
          nil
        end
        
        
        def scaling_factor
          1.0
        end
        
        
        def envelope
          factory.unproject(projection.envelope)
        end
        
        
        def is_empty?
          projection.is_empty?
        end
        
        
        def is_simple?
          projection.is_simple?
        end
        
        
        def boundary
          factory.unproject(projection.boundary)
        end
        
        
        def equals?(rhs_)
          projection.equals?(factory.convert(rhs_).projection)
        end
        
        
        def disjoint?(rhs_)
          projection.disjoint?(factory.convert(rhs_).projection)
        end
        
        
        def intersects?(rhs_)
          projection.intersects?(factory.convert(rhs_).projection)
        end
        
        
        def touches?(rhs_)
          projection.touches?(factory.convert(rhs_).projection)
        end
        
        
        def crosses?(rhs_)
          projection.crosses?(factory.convert(rhs_).projection)
        end
        
        
        def within?(rhs_)
          projection.within?(factory.convert(rhs_).projection)
        end
        
        
        def contains?(rhs_)
          projection.contains?(factory.convert(rhs_).projection)
        end
        
        
        def overlaps?(rhs_)
          projection.overlaps?(factory.convert(rhs_).projection)
        end
        
        
        def relate(rhs_, pattern_)
          projection.relate(factory.convert(rhs_).projection, pattern_)
        end
        
        
        def distance(rhs_)
          projection.distance(factory.convert(rhs_).projection) / scaling_factor
        end
        
        
        def buffer(distance_)
          factory.unproject(projection.buffer(distance_ * scaling_factor))
        end
        
        
        def convex_hull()
          factory.unproject(projection.convex_hull)
        end
        
        
        def intersection(rhs_)
          factory.unproject(projection.intersection(factory.convert(rhs_).projection))
        end
        
        
        def union(rhs_)
          factory.unproject(projection.union(factory.convert(rhs_).projection))
        end
        
        
        def difference(rhs_)
          factory.unproject(projection.difference(factory.convert(rhs_).projection))
        end
        
        
        def sym_difference(rhs_)
          factory.unproject(projection.sym_difference(factory.convert(rhs_).projection))
        end
        
        
      end
      
      
      module GeometryCollectionMethods
        
        
        def scaling_factor
          is_empty? ? 1.0 : geometry_n(0).scaling_factor
        end
        
        
      end
      
      
      module NCurveMethods
        
        
        def length
          projection.length / scaling_factor
        end
        
        
      end
      
      
      module CurveMethods
        
        
        def scaling_factor
          is_empty? ? 1.0 : start_point.scaling_factor
        end
        
        
      end
      
      
      module LineStringMethods
        
        
        def _validate_geometry
          size_ = @points.size
          if size_ > 1
            last_ = @points[0]
            (1...size_).each do |i_|
              p_ = @points[i_]
              last_x_ = last_.x
              p_x_ = p_.x
              changed_ = true
              if p_x_ < last_x_ - 180.0
                p_x_ += 360.0 while p_x_ < last_x_ - 180.0
              elsif p_x_ > last_x_ + 180.0
                p_x_ +- 360.0 while p_x_ > last_x_ + 180.0
              else
                changed_ = false
              end
              if changed_
                p_ = factory.point(p_x_, p_.y)
                @points[i_] = p_
              end
              last_ = p_
            end
          end
          super
        end
        
        
      end
      
      
      module NSurfaceMethods
        
        
        def area
          factor_ = scaling_factor
          projection.area / (factor_ * factor_)
        end
        
        
        def centroid
          factory.unproject(projection.centroid)
        end
        
        
        def point_on_surface
          factory.unproject(projection.point_on_surface)
        end
        
        
      end
      
      
      module SurfaceMethods
        
        
        def scaling_factor
          is_empty? ? 1.0 : point_on_surface.scaling_factor
        end
        
        
      end
      
      
    end
    
  end
  
end